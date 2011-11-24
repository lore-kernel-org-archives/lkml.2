Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1KXIG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:06:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54136 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1KXIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:06:57 -0500
Message-ID: <1322122004.10476.1.camel@phoenix>
Subject: [PATCH 1/3] leds: Convert led platform drivers to
 module_platform_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 24 Nov 2011 16:06:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code for platform driver registration
into module_platform_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-88pm860x.c      |   12 +-----------
 drivers/leds/leds-adp5520.c       |   12 +-----------
 drivers/leds/leds-ams-delta.c     |   13 +------------
 drivers/leds/leds-asic3.c         |   16 ++--------------
 drivers/leds/leds-atmel-pwm.c     |   17 +++--------------
 drivers/leds/leds-cobalt-qube.c   |   17 ++---------------
 drivers/leds/leds-da903x.c        |   12 +-----------
 drivers/leds/leds-fsg.c           |   15 +--------------
 drivers/leds/leds-gpio.c          |   16 ++--------------
 drivers/leds/leds-hp6xx.c         |   17 ++---------------
 drivers/leds/leds-lt3593.c        |   16 ++--------------
 drivers/leds/leds-mc13783.c       |   12 +-----------
 drivers/leds/leds-netxbig.c       |   15 ++-------------
 drivers/leds/leds-ns2.c           |   15 ++-------------
 drivers/leds/leds-pwm.c           |   13 +------------
 drivers/leds/leds-rb532.c         |   16 ++--------------
 drivers/leds/leds-regulator.c     |   12 +-----------
 drivers/leds/leds-renesas-tpu.c   |   13 +------------
 drivers/leds/leds-s3c24xx.c       |   13 +------------
 drivers/leds/leds-wm831x-status.c |   12 +-----------
 drivers/leds/leds-wm8350.c        |   12 +-----------
 21 files changed, 31 insertions(+), 265 deletions(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 0810604..4ca0062 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -238,17 +238,7 @@ static struct platform_driver pm860x_led_driver = {
 	.remove	= pm860x_led_remove,
 };
 
-static int __devinit pm860x_led_init(void)
-{
-	return platform_driver_register(&pm860x_led_driver);
-}
-module_init(pm860x_led_init);
-
-static void __devexit pm860x_led_exit(void)
-{
-	platform_driver_unregister(&pm860x_led_driver);
-}
-module_exit(pm860x_led_exit);
+module_platform_driver(pm860x_led_driver);
 
 MODULE_DESCRIPTION("LED driver for Marvell PM860x");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/leds/leds-adp5520.c b/drivers/leds/leds-adp5520.c
index 7ba4c7b..b1400db 100644
--- a/drivers/leds/leds-adp5520.c
+++ b/drivers/leds/leds-adp5520.c
@@ -213,17 +213,7 @@ static struct platform_driver adp5520_led_driver = {
 	.remove		= __devexit_p(adp5520_led_remove),
 };
 
-static int __init adp5520_led_init(void)
-{
-	return platform_driver_register(&adp5520_led_driver);
-}
-module_init(adp5520_led_init);
-
-static void __exit adp5520_led_exit(void)
-{
-	platform_driver_unregister(&adp5520_led_driver);
-}
-module_exit(adp5520_led_exit);
+module_platform_driver(adp5520_led_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("LEDS ADP5520(01) Driver");
diff --git a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
index 8c00937..0742835 100644
--- a/drivers/leds/leds-ams-delta.c
+++ b/drivers/leds/leds-ams-delta.c
@@ -118,18 +118,7 @@ static struct platform_driver ams_delta_led_driver = {
 	},
 };
 
-static int __init ams_delta_led_init(void)
-{
-	return platform_driver_register(&ams_delta_led_driver);
-}
-
-static void __exit ams_delta_led_exit(void)
-{
-	platform_driver_unregister(&ams_delta_led_driver);
-}
-
-module_init(ams_delta_led_init);
-module_exit(ams_delta_led_exit);
+module_platform_driver(ams_delta_led_driver);
 
 MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
 MODULE_DESCRIPTION("Amstrad Delta LED driver");
diff --git a/drivers/leds/leds-asic3.c b/drivers/leds/leds-asic3.c
index 48d9fe6..525a924 100644
--- a/drivers/leds/leds-asic3.c
+++ b/drivers/leds/leds-asic3.c
@@ -179,21 +179,9 @@ static struct platform_driver asic3_led_driver = {
 	},
 };
 
-MODULE_ALIAS("platform:leds-asic3");
-
-static int __init asic3_led_init(void)
-{
-	return platform_driver_register(&asic3_led_driver);
-}
-
-static void __exit asic3_led_exit(void)
-{
-	platform_driver_unregister(&asic3_led_driver);
-}
-
-module_init(asic3_led_init);
-module_exit(asic3_led_exit);
+module_platform_driver(asic3_led_driver);
 
 MODULE_AUTHOR("Paul Parsons <lost.distance@yahoo.com>");
 MODULE_DESCRIPTION("HTC ASIC3 LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-asic3");
diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
index 109c875..800243b 100644
--- a/drivers/leds/leds-atmel-pwm.c
+++ b/drivers/leds/leds-atmel-pwm.c
@@ -134,29 +134,18 @@ static int __exit pwmled_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:leds-atmel-pwm");
-
 static struct platform_driver pwmled_driver = {
 	.driver = {
 		.name =		"leds-atmel-pwm",
 		.owner =	THIS_MODULE,
 	},
 	/* REVISIT add suspend() and resume() methods */
+	.probe =	pwmled_probe,
 	.remove =	__exit_p(pwmled_remove),
 };
 
-static int __init modinit(void)
-{
-	return platform_driver_probe(&pwmled_driver, pwmled_probe);
-}
-module_init(modinit);
-
-static void __exit modexit(void)
-{
-	platform_driver_unregister(&pwmled_driver);
-}
-module_exit(modexit);
+module_platform_driver(pwmled_driver);
 
 MODULE_DESCRIPTION("Driver for LEDs with PWM-controlled brightness");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-atmel-pwm");
diff --git a/drivers/leds/leds-cobalt-qube.c b/drivers/leds/leds-cobalt-qube.c
index da5fb01..6a8725c 100644
--- a/drivers/leds/leds-cobalt-qube.c
+++ b/drivers/leds/leds-cobalt-qube.c
@@ -75,9 +75,6 @@ static int __devexit cobalt_qube_led_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:cobalt-qube-leds");
-
 static struct platform_driver cobalt_qube_led_driver = {
 	.probe	= cobalt_qube_led_probe,
 	.remove	= __devexit_p(cobalt_qube_led_remove),
@@ -87,19 +84,9 @@ static struct platform_driver cobalt_qube_led_driver = {
 	},
 };
 
-static int __init cobalt_qube_led_init(void)
-{
-	return platform_driver_register(&cobalt_qube_led_driver);
-}
-
-static void __exit cobalt_qube_led_exit(void)
-{
-	platform_driver_unregister(&cobalt_qube_led_driver);
-}
-
-module_init(cobalt_qube_led_init);
-module_exit(cobalt_qube_led_exit);
+module_platform_driver(cobalt_qube_led_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Front LED support for Cobalt Server");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_ALIAS("platform:cobalt-qube-leds");
diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index f28931c..d9cd73e 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -158,17 +158,7 @@ static struct platform_driver da903x_led_driver = {
 	.remove		= __devexit_p(da903x_led_remove),
 };
 
-static int __init da903x_led_init(void)
-{
-	return platform_driver_register(&da903x_led_driver);
-}
-module_init(da903x_led_init);
-
-static void __exit da903x_led_exit(void)
-{
-	platform_driver_unregister(&da903x_led_driver);
-}
-module_exit(da903x_led_exit);
+module_platform_driver(da903x_led_driver);
 
 MODULE_DESCRIPTION("LEDs driver for Dialog Semiconductor DA9030/DA9034");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>"
diff --git a/drivers/leds/leds-fsg.c b/drivers/leds/leds-fsg.c
index 49aceff..b9053fa 100644
--- a/drivers/leds/leds-fsg.c
+++ b/drivers/leds/leds-fsg.c
@@ -224,20 +224,7 @@ static struct platform_driver fsg_led_driver = {
 	},
 };
 
-
-static int __init fsg_led_init(void)
-{
-	return platform_driver_register(&fsg_led_driver);
-}
-
-static void __exit fsg_led_exit(void)
-{
-	platform_driver_unregister(&fsg_led_driver);
-}
-
-
-module_init(fsg_led_init);
-module_exit(fsg_led_exit);
+module_platform_driver(fsg_led_driver);
 
 MODULE_AUTHOR("Rod Whitby <rod@whitby.id.au>");
 MODULE_DESCRIPTION("Freecom FSG-3 LED driver");
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 399a86f..7df74cb 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -293,21 +293,9 @@ static struct platform_driver gpio_led_driver = {
 	},
 };
 
-MODULE_ALIAS("platform:leds-gpio");
-
-static int __init gpio_led_init(void)
-{
-	return platform_driver_register(&gpio_led_driver);
-}
-
-static void __exit gpio_led_exit(void)
-{
-	platform_driver_unregister(&gpio_led_driver);
-}
-
-module_init(gpio_led_init);
-module_exit(gpio_led_exit);
+module_platform_driver(gpio_led_driver);
 
 MODULE_AUTHOR("Raphael Assenat <raph@8d.com>, Trent Piepho <tpiepho@freescale.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-gpio");
diff --git a/drivers/leds/leds-hp6xx.c b/drivers/leds/leds-hp6xx.c
index bcfbd3a..366b605 100644
--- a/drivers/leds/leds-hp6xx.c
+++ b/drivers/leds/leds-hp6xx.c
@@ -79,9 +79,6 @@ static int hp6xxled_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:hp6xx-led");
-
 static struct platform_driver hp6xxled_driver = {
 	.probe		= hp6xxled_probe,
 	.remove		= hp6xxled_remove,
@@ -91,19 +88,9 @@ static struct platform_driver hp6xxled_driver = {
 	},
 };
 
-static int __init hp6xxled_init(void)
-{
-	return platform_driver_register(&hp6xxled_driver);
-}
-
-static void __exit hp6xxled_exit(void)
-{
-	platform_driver_unregister(&hp6xxled_driver);
-}
-
-module_init(hp6xxled_init);
-module_exit(hp6xxled_exit);
+module_platform_driver(hp6xxled_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 6xx LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:hp6xx-led");
diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index 53f67b8..e311a96c 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -199,21 +199,9 @@ static struct platform_driver lt3593_led_driver = {
 	},
 };
 
-MODULE_ALIAS("platform:leds-lt3593");
-
-static int __init lt3593_led_init(void)
-{
-	return platform_driver_register(&lt3593_led_driver);
-}
-
-static void __exit lt3593_led_exit(void)
-{
-	platform_driver_unregister(&lt3593_led_driver);
-}
-
-module_init(lt3593_led_init);
-module_exit(lt3593_led_exit);
+module_platform_driver(lt3593_led_driver);
 
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("LED driver for LT3593 controllers");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-lt3593");
diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index b3393a9..c61e8c4 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -385,17 +385,7 @@ static struct platform_driver mc13783_led_driver = {
 	.remove		= __devexit_p(mc13783_led_remove),
 };
 
-static int __init mc13783_led_init(void)
-{
-	return platform_driver_register(&mc13783_led_driver);
-}
-module_init(mc13783_led_init);
-
-static void __exit mc13783_led_exit(void)
-{
-	platform_driver_unregister(&mc13783_led_driver);
-}
-module_exit(mc13783_led_exit);
+module_platform_driver(mc13783_led_driver);
 
 MODULE_DESCRIPTION("LEDs driver for Freescale MC13783 PMIC");
 MODULE_AUTHOR("Philippe Retornaz <philippe.retornaz@epfl.ch>");
diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index f2e51c1..8c7a4ea 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -429,21 +429,10 @@ static struct platform_driver netxbig_led_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-MODULE_ALIAS("platform:leds-netxbig");
-
-static int __init netxbig_led_init(void)
-{
-	return platform_driver_register(&netxbig_led_driver);
-}
 
-static void __exit netxbig_led_exit(void)
-{
-	platform_driver_unregister(&netxbig_led_driver);
-}
-
-module_init(netxbig_led_init);
-module_exit(netxbig_led_exit);
+module_platform_driver(netxbig_led_driver);
 
 MODULE_AUTHOR("Simon Guinot <sguinot@lacie.com>");
 MODULE_DESCRIPTION("LED driver for LaCie xBig Network boards");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-netxbig");
diff --git a/drivers/leds/leds-ns2.c b/drivers/leds/leds-ns2.c
index 37b7d0c..2f0a144 100644
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@ -323,21 +323,10 @@ static struct platform_driver ns2_led_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-MODULE_ALIAS("platform:leds-ns2");
-
-static int __init ns2_led_init(void)
-{
-	return platform_driver_register(&ns2_led_driver);
-}
 
-static void __exit ns2_led_exit(void)
-{
-	platform_driver_unregister(&ns2_led_driver);
-}
-
-module_init(ns2_led_init);
-module_exit(ns2_led_exit);
+module_platform_driver(ns2_led_driver);
 
 MODULE_AUTHOR("Simon Guinot <sguinot@lacie.com>");
 MODULE_DESCRIPTION("Network Space v2 LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-ns2");
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 666daf7..3ed92f3 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -135,18 +135,7 @@ static struct platform_driver led_pwm_driver = {
 	},
 };
 
-static int __init led_pwm_init(void)
-{
-	return platform_driver_register(&led_pwm_driver);
-}
-
-static void __exit led_pwm_exit(void)
-{
-	platform_driver_unregister(&led_pwm_driver);
-}
-
-module_init(led_pwm_init);
-module_exit(led_pwm_exit);
+module_platform_driver(led_pwm_driver);
 
 MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
 MODULE_DESCRIPTION("PWM LED driver for PXA");
diff --git a/drivers/leds/leds-rb532.c b/drivers/leds/leds-rb532.c
index c3525f3..a7815b6 100644
--- a/drivers/leds/leds-rb532.c
+++ b/drivers/leds/leds-rb532.c
@@ -57,21 +57,9 @@ static struct platform_driver rb532_led_driver = {
 	},
 };
 
-static int __init rb532_led_init(void)
-{
-	return platform_driver_register(&rb532_led_driver);
-}
-
-static void __exit rb532_led_exit(void)
-{
-	platform_driver_unregister(&rb532_led_driver);
-}
-
-module_init(rb532_led_init);
-module_exit(rb532_led_exit);
-
-MODULE_ALIAS("platform:rb532-led");
+module_platform_driver(rb532_led_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for Routerboard532");
 MODULE_AUTHOR("Phil Sutter <n0-1@freewrt.org>");
+MODULE_ALIAS("platform:rb532-led");
diff --git a/drivers/leds/leds-regulator.c b/drivers/leds/leds-regulator.c
index 8497f56..df7e963 100644
--- a/drivers/leds/leds-regulator.c
+++ b/drivers/leds/leds-regulator.c
@@ -229,17 +229,7 @@ static struct platform_driver regulator_led_driver = {
 	.remove = __devexit_p(regulator_led_remove),
 };
 
-static int __init regulator_led_init(void)
-{
-	return platform_driver_register(&regulator_led_driver);
-}
-module_init(regulator_led_init);
-
-static void __exit regulator_led_exit(void)
-{
-	platform_driver_unregister(&regulator_led_driver);
-}
-module_exit(regulator_led_exit);
+module_platform_driver(regulator_led_driver);
 
 MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("Regulator driven LED driver");
diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
index 3ee540e..32fe337 100644
--- a/drivers/leds/leds-renesas-tpu.c
+++ b/drivers/leds/leds-renesas-tpu.c
@@ -339,18 +339,7 @@ static struct platform_driver r_tpu_device_driver = {
 	}
 };
 
-static int __init r_tpu_init(void)
-{
-	return platform_driver_register(&r_tpu_device_driver);
-}
-
-static void __exit r_tpu_exit(void)
-{
-	platform_driver_unregister(&r_tpu_device_driver);
-}
-
-module_init(r_tpu_init);
-module_exit(r_tpu_exit);
+module_platform_driver(r_tpu_device_driver);
 
 MODULE_AUTHOR("Magnus Damm");
 MODULE_DESCRIPTION("Renesas TPU LED Driver");
diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 29f8b0f..bd0a5ed 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -121,18 +121,7 @@ static struct platform_driver s3c24xx_led_driver = {
 	},
 };
 
-static int __init s3c24xx_led_init(void)
-{
-	return platform_driver_register(&s3c24xx_led_driver);
-}
-
-static void __exit s3c24xx_led_exit(void)
-{
-	platform_driver_unregister(&s3c24xx_led_driver);
-}
-
-module_init(s3c24xx_led_init);
-module_exit(s3c24xx_led_exit);
+module_platform_driver(s3c24xx_led_driver);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("S3C24XX LED driver");
diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
index b1eb34c..444a68d 100644
--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -325,17 +325,7 @@ static struct platform_driver wm831x_status_driver = {
 	.remove = wm831x_status_remove,
 };
 
-static int __devinit wm831x_status_init(void)
-{
-	return platform_driver_register(&wm831x_status_driver);
-}
-module_init(wm831x_status_init);
-
-static void wm831x_status_exit(void)
-{
-	platform_driver_unregister(&wm831x_status_driver);
-}
-module_exit(wm831x_status_exit);
+module_platform_driver(wm831x_status_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("WM831x status LED driver");
diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index 4a12765..390c0f6 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -295,17 +295,7 @@ static struct platform_driver wm8350_led_driver = {
 	.shutdown = wm8350_led_shutdown,
 };
 
-static int __devinit wm8350_led_init(void)
-{
-	return platform_driver_register(&wm8350_led_driver);
-}
-module_init(wm8350_led_init);
-
-static void wm8350_led_exit(void)
-{
-	platform_driver_unregister(&wm8350_led_driver);
-}
-module_exit(wm8350_led_exit);
+module_platform_driver(wm8350_led_driver);
 
 MODULE_AUTHOR("Mark Brown");
 MODULE_DESCRIPTION("WM8350 LED driver");
-- 
1.7.5.4



