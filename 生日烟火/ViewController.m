//
//  ViewController.m
//  生日烟火
//
//  Created by rexsu on 2017/2/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "ViewController.h"
#import "ActionButton.h"
#import "Stars.h"
#import "FireView.h"
#import "UIView+Extension.h"

#define Star_WidthWithHeight 15
#define Windows_Width [UIScreen mainScreen].bounds.size.width
#define Windows_Height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
{
    CABasicAnimation *rotation;
    BOOL first;
    
}
@property (nonatomic,strong)FireView * fireView;

@property (nonatomic,strong)Stars * star;

@property (nonatomic,strong)CAEmitterLayer * boomLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self boom];
    
    _star = [[Stars alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - Star_WidthWithHeight, self.view.bounds.size.height - Star_WidthWithHeight, Star_WidthWithHeight, Star_WidthWithHeight)];
    ViewController * weakSelf = self;
    [_star actionFireWithBlock:^{
        FireView * fire = [[FireView alloc]initWithFrame:weakSelf.view.bounds];
        weakSelf.view = fire;
    }];
    [_star actionBoomWithBlock:^{
        if (first) {
            [weakSelf actionBoom2];
        }else{
            [weakSelf actionBoom1];
        }
        first = !first;
    }];
    [self.view addSubview:_star];
}

- (IBAction)action:(ActionButton *)sender {
    sender.selected = !sender.selected;
    //[_star animationMove];
    [self performSelector:@selector(starGo) withObject:nil afterDelay:1.3];
    //[self animationMove];
}

-(void)starGo{
    [_star animationMove];
}

-(void)boom{
    
    CAEmitterCell * cell            = [CAEmitterCell emitterCell];
    cell.name                       = @"explosion";
    cell.birthRate                  = 0;
    cell.velocity                   = 110;
    cell.velocityRange              = 20;
    cell.contents                   = (id)[UIImage imageNamed:@"1_star_3@3x"].CGImage;
    cell.alphaRange                 = 0.10;
    cell.alphaSpeed                 = -1.0;
    cell.lifetime                   = 0.5;
    cell.lifetimeRange              = 0.2;
    cell.scale                      = 0.01;

    
    
    self.boomLayer                            = [CAEmitterLayer layer];
    self.boomLayer.name                       = @"emitterLayer";
    self.boomLayer.position                   = CGPointMake(Windows_Width / 2, Windows_Height - _star.height/2);
    self.boomLayer.emitterMode                = kCAEmitterLayerOutline;
    self.boomLayer.emitterShape               = kCAEmitterLayerCircle;
    self.boomLayer.renderMode                 = kCAEmitterLayerOldestFirst;
    self.boomLayer.emitterSize                = CGSizeMake(0, 0);
    self.boomLayer.masksToBounds              = NO;
    
    self.boomLayer.emitterCells               = @[cell];
    [self.view.layer addSublayer:self.boomLayer];
    
    
}

-(void)actionBoom1{
    [self.boomLayer setValue:@4500 forKeyPath:@"emitterCells.explosion.birthRate"];
    [self performSelector:@selector(stopBoom) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(changeBoomPoint) withObject:nil afterDelay:2];
}
-(void)actionBoom2{
    
    [self.boomLayer setValue:@4500 forKeyPath:@"emitterCells.explosion.birthRate"];
    [self performSelector:@selector(stopBoom) withObject:nil afterDelay:0.2];
}
-(void)stopBoom{
        [self.boomLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}
-(void)changeBoomPoint{
    [self.boomLayer setValue:@(Windows_Width / 2) forKeyPath:@"position.x"];
    [self.boomLayer setValue:@(80) forKeyPath:@"position.y"];
}


@end
