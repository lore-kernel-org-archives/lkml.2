Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1KZCTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 21:19:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63326 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1KZCTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 21:19:35 -0500
Message-ID: <1322273963.10633.1.camel@phoenix>
Subject: [PATCH] backlight: convert drivers/video/backlight/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 26 Nov 2011 10:19:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/video/backlight/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/88pm860x_bl.c        |   12 +-----------
 drivers/video/backlight/adp5520_bl.c         |   12 +-----------
 drivers/video/backlight/adx_bl.c             |   13 +------------
 drivers/video/backlight/da903x_bl.c          |   12 +-----------
 drivers/video/backlight/ep93xx_bl.c          |   12 +-----------
 drivers/video/backlight/generic_bl.c         |   13 +------------
 drivers/video/backlight/jornada720_bl.c      |   13 +------------
 drivers/video/backlight/jornada720_lcd.c     |   13 +------------
 drivers/video/backlight/max8925_bl.c         |   12 +-----------
 drivers/video/backlight/omap1_bl.c           |   13 +------------
 drivers/video/backlight/pcf50633-backlight.c |   12 +-----------
 drivers/video/backlight/platform_lcd.c       |   13 +------------
 drivers/video/backlight/pwm_bl.c             |   12 +-----------
 drivers/video/backlight/wm831x_bl.c          |   12 +-----------
 14 files changed, 14 insertions(+), 160 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 1105fa1..a1376dc 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -270,17 +270,7 @@ static struct platform_driver pm860x_backlight_driver = {
 	.remove		= pm860x_backlight_remove,
 };
 
-static int __init pm860x_backlight_init(void)
-{
-	return platform_driver_register(&pm860x_backlight_driver);
-}
-module_init(pm860x_backlight_init);
-
-static void __exit pm860x_backlight_exit(void)
-{
-	platform_driver_unregister(&pm860x_backlight_driver);
-}
-module_exit(pm860x_backlight_exit);
+module_platform_driver(pm860x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Marvell Semiconductor 88PM8606");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index dfb763e..2e630bf 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -384,17 +384,7 @@ static struct platform_driver adp5520_bl_driver = {
 	.resume		= adp5520_bl_resume,
 };
 
-static int __init adp5520_bl_init(void)
-{
-	return platform_driver_register(&adp5520_bl_driver);
-}
-module_init(adp5520_bl_init);
-
-static void __exit adp5520_bl_exit(void)
-{
-	platform_driver_unregister(&adp5520_bl_driver);
-}
-module_exit(adp5520_bl_exit);
+module_platform_driver(adp5520_bl_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP5520(01) Backlight Driver");
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index c861c41..a69c61b 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -164,18 +164,7 @@ static struct platform_driver adx_backlight_driver = {
 	},
 };
 
-static int __init adx_backlight_init(void)
-{
-	return platform_driver_register(&adx_backlight_driver);
-}
-
-static void __exit adx_backlight_exit(void)
-{
-	platform_driver_unregister(&adx_backlight_driver);
-}
-
-module_init(adx_backlight_init);
-module_exit(adx_backlight_exit);
+module_platform_driver(adx_backlight_driver);
 
 MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
 MODULE_DESCRIPTION("Avionic Design Xanthos Backlight Driver");
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index d68f14b..abb4a06 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -199,17 +199,7 @@ static struct platform_driver da903x_backlight_driver = {
 	.remove		= da903x_backlight_remove,
 };
 
-static int __init da903x_backlight_init(void)
-{
-	return platform_driver_register(&da903x_backlight_driver);
-}
-module_init(da903x_backlight_init);
-
-static void __exit da903x_backlight_exit(void)
-{
-	platform_driver_unregister(&da903x_backlight_driver);
-}
-module_exit(da903x_backlight_exit);
+module_platform_driver(da903x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Dialog Semiconductor DA9030/DA9034");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>"
diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index c74a6f4..32b9167 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -144,17 +144,7 @@ static struct platform_driver ep93xxbl_driver = {
 	.resume		= ep93xxbl_resume,
 };
 
-static int __init ep93xxbl_init(void)
-{
-	return platform_driver_register(&ep93xxbl_driver);
-}
-module_init(ep93xxbl_init);
-
-static void __exit ep93xxbl_exit(void)
-{
-	platform_driver_unregister(&ep93xxbl_driver);
-}
-module_exit(ep93xxbl_exit);
+module_platform_driver(ep93xxbl_driver);
 
 MODULE_DESCRIPTION("EP93xx Backlight Driver");
 MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index adb1914..9ce6170 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -132,18 +132,7 @@ static struct platform_driver genericbl_driver = {
 	},
 };
 
-static int __init genericbl_init(void)
-{
-	return platform_driver_register(&genericbl_driver);
-}
-
-static void __exit genericbl_exit(void)
-{
-	platform_driver_unregister(&genericbl_driver);
-}
-
-module_init(genericbl_init);
-module_exit(genericbl_exit);
+module_platform_driver(genericbl_driver);
 
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Generic Backlight Driver");
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index de65d80..2f8af5d 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -147,19 +147,8 @@ static struct platform_driver jornada_bl_driver = {
 	},
 };
 
-static int __init jornada_bl_init(void)
-{
-	return platform_driver_register(&jornada_bl_driver);
-}
-
-static void __exit jornada_bl_exit(void)
-{
-	platform_driver_unregister(&jornada_bl_driver);
-}
+module_platform_driver(jornada_bl_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson>");
 MODULE_DESCRIPTION("HP Jornada 710/720/728 Backlight driver");
 MODULE_LICENSE("GPL");
-
-module_init(jornada_bl_init);
-module_exit(jornada_bl_exit);
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index d2ff658..22d231a 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -135,19 +135,8 @@ static struct platform_driver jornada_lcd_driver = {
 	},
 };
 
-static int __init jornada_lcd_init(void)
-{
-	return platform_driver_register(&jornada_lcd_driver);
-}
-
-static void __exit jornada_lcd_exit(void)
-{
-	platform_driver_unregister(&jornada_lcd_driver);
-}
+module_platform_driver(jornada_lcd_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 710/720/728 LCD driver");
 MODULE_LICENSE("GPL");
-
-module_init(jornada_lcd_init);
-module_exit(jornada_lcd_exit);
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 7bbc802..c915e3b 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -188,17 +188,7 @@ static struct platform_driver max8925_backlight_driver = {
 	.remove		= __devexit_p(max8925_backlight_remove),
 };
 
-static int __init max8925_backlight_init(void)
-{
-	return platform_driver_register(&max8925_backlight_driver);
-}
-module_init(max8925_backlight_init);
-
-static void __exit max8925_backlight_exit(void)
-{
-	platform_driver_unregister(&max8925_backlight_driver);
-};
-module_exit(max8925_backlight_exit);
+module_platform_driver(max8925_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Maxim MAX8925");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 08d26a7..d8cde27 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -195,18 +195,7 @@ static struct platform_driver omapbl_driver = {
 	},
 };
 
-static int __init omapbl_init(void)
-{
-	return platform_driver_register(&omapbl_driver);
-}
-
-static void __exit omapbl_exit(void)
-{
-	platform_driver_unregister(&omapbl_driver);
-}
-
-module_init(omapbl_init);
-module_exit(omapbl_exit);
+module_platform_driver(omapbl_driver);
 
 MODULE_AUTHOR("Andrzej Zaborowski <balrog@zabor.org>");
 MODULE_DESCRIPTION("OMAP LCD Backlight driver");
diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index ef5628d..13e88b7 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -173,17 +173,7 @@ static struct platform_driver pcf50633_bl_driver = {
 	},
 };
 
-static int __init pcf50633_bl_init(void)
-{
-	return platform_driver_register(&pcf50633_bl_driver);
-}
-module_init(pcf50633_bl_init);
-
-static void __exit pcf50633_bl_exit(void)
-{
-	platform_driver_unregister(&pcf50633_bl_driver);
-}
-module_exit(pcf50633_bl_exit);
+module_platform_driver(pcf50633_bl_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("PCF50633 backlight driver");
diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 302330ac..187da59 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -157,18 +157,7 @@ static struct platform_driver platform_lcd_driver = {
 	.resume         = platform_lcd_resume,
 };
 
-static int __init platform_lcd_init(void)
-{
-	return platform_driver_register(&platform_lcd_driver);
-}
-
-static void __exit platform_lcd_cleanup(void)
-{
-	platform_driver_unregister(&platform_lcd_driver);
-}
-
-module_init(platform_lcd_init);
-module_exit(platform_lcd_cleanup);
+module_platform_driver(platform_lcd_driver);
 
 MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 8b5b2a4..b811e8f 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -207,17 +207,7 @@ static struct platform_driver pwm_backlight_driver = {
 	.resume		= pwm_backlight_resume,
 };
 
-static int __init pwm_backlight_init(void)
-{
-	return platform_driver_register(&pwm_backlight_driver);
-}
-module_init(pwm_backlight_init);
-
-static void __exit pwm_backlight_exit(void)
-{
-	platform_driver_unregister(&pwm_backlight_driver);
-}
-module_exit(pwm_backlight_exit);
+module_platform_driver(pwm_backlight_driver);
 
 MODULE_DESCRIPTION("PWM based Backlight Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index fbe9e93..4e915f5 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -236,17 +236,7 @@ static struct platform_driver wm831x_backlight_driver = {
 	.remove		= wm831x_backlight_remove,
 };
 
-static int __init wm831x_backlight_init(void)
-{
-	return platform_driver_register(&wm831x_backlight_driver);
-}
-module_init(wm831x_backlight_init);
-
-static void __exit wm831x_backlight_exit(void)
-{
-	platform_driver_unregister(&wm831x_backlight_driver);
-}
-module_exit(wm831x_backlight_exit);
+module_platform_driver(wm831x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for WM831x PMICs");
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com");
-- 
1.7.5.4



