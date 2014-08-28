//
//  GameViewController.m
//  HBDMemo
//
//  Created by vade on 8/28/14.
//  Copyright (c) 2014 vade. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a new scene
    SCNScene *scene = [SCNScene scene];

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node
    SCNText *HBDGeom = [SCNText textWithString:@"Happy Birthday!@#!@#" extrusionDepth:0.75];
	HBDGeom.chamferRadius = 0.1;
	
	SCNNode* HBD = [SCNNode node];
	HBD.geometry = HBDGeom;
	HBD.geometry.firstMaterial.diffuse.contents = [UIColor yellowColor];
	HBD.geometry.firstMaterial.specular.contents = [UIColor redColor];
	HBD.geometry.firstMaterial.specular.intensity = 1.0;
	HBD.geometry.firstMaterial.shininess = 10.0;
	HBD.geometry.firstMaterial.doubleSided = YES;
	
	HBD.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithGeometry:HBDGeom options:@{SCNPhysicsShapeTypeKey : SCNPhysicsShapeTypeConcavePolyhedron}]];
	
	// Particle system @!#
	SCNParticleSystem* HBDParticles = [SCNParticleSystem particleSystemNamed:@"MyParticleSystem" inDirectory:nil];
	HBDParticles.emitterShape = HBDGeom;
	[HBD addParticleSystem:HBDParticles];
	
	// Physics Field
	HBD.physicsField = [SCNPhysicsField noiseFieldWithSmoothness:1.0 animationSpeed:1.0];
	HBD.physicsField.strength = 10;
	
//	[scene addParticleSystem:HBDParticles withTransform:SCNMatrix4Identity];
	
	
	
    // animate the 3d object
    [HBD runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
	
	[scene.rootNode addChildNode:HBD];
	
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
