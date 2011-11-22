Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1KVJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:06:00 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:24345 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1KVJCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:02:54 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20TRIVIAL=201/5=5D=20Input=3A=20keyboard=3A=20use=20macro=20module=5Fplatform=5Fdriver=28=29?=
Date: Tue, 22 Nov 2011 17:00:42 +0800
Message-Id: <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8-rc2
In-Reply-To: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JJ Ding <dgdunix@gmail.com>

Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
save some platform_driver boilerplate code. Use it.

Signed-off-by: JJ Ding <dgdunix@gmail.com>
---
 drivers/input/keyboard/adp5520-keys.c       |   13 +------------
 drivers/input/keyboard/amikbd.c             |   15 +--------------
 drivers/input/keyboard/bf54x-keys.c         |   14 +-------------
 drivers/input/keyboard/davinci_keyscan.c    |   13 +------------
 drivers/input/keyboard/ep93xx_keypad.c      |   14 +-------------
 drivers/input/keyboard/gpio_keys_polled.c   |   14 +-------------
 drivers/input/keyboard/imx_keypad.c         |   14 +-------------
 drivers/input/keyboard/jornada680_kbd.c     |   14 +-------------
 drivers/input/keyboard/jornada720_kbd.c     |   14 +-------------
 drivers/input/keyboard/matrix_keypad.c      |   14 +-------------
 drivers/input/keyboard/nomadik-ske-keypad.c |   13 +------------
 drivers/input/keyboard/omap-keypad.c        |   15 +--------------
 drivers/input/keyboard/omap4-keypad.c       |   13 +------------
 drivers/input/keyboard/opencores-kbd.c      |   13 +------------
 drivers/input/keyboard/pmic8xxx-keypad.c    |   13 +------------
 drivers/input/keyboard/pxa27x_keypad.c      |   14 +-------------
 drivers/input/keyboard/pxa930_rotary.c      |   13 +------------
 drivers/input/keyboard/samsung-keypad.c     |   13 +------------
 drivers/input/keyboard/sh_keysc.c           |   14 +-------------
 drivers/input/keyboard/spear-keyboard.c     |   13 +------------
 drivers/input/keyboard/stmpe-keypad.c       |   13 +------------
 drivers/input/keyboard/tc3589x-keypad.c     |   13 +------------
 drivers/input/keyboard/tegra-kbc.c          |   13 +------------
 drivers/input/keyboard/tnetv107x-keypad.c   |   14 +-------------
 drivers/input/keyboard/twl4030_keypad.c     |   13 +------------
 drivers/input/keyboard/w90p910_keypad.c     |   14 +-------------
 26 files changed, 26 insertions(+), 327 deletions(-)

diff --git a/drivers/input/keyboard/adp5520-keys.c b/drivers/input/keyboard/adp5520-keys.c
index 3db8006..e9e8674 100644
--- a/drivers/input/keyboard/adp5520-keys.c
+++ b/drivers/input/keyboard/adp5520-keys.c
@@ -202,18 +202,7 @@ static struct platform_driver adp5520_keys_driver = {
 	.probe		= adp5520_keys_probe,
 	.remove		= __devexit_p(adp5520_keys_remove),
 };
-
-static int __init adp5520_keys_init(void)
-{
-	return platform_driver_register(&adp5520_keys_driver);
-}
-module_init(adp5520_keys_init);
-
-static void __exit adp5520_keys_exit(void)
-{
-	platform_driver_unregister(&adp5520_keys_driver);
-}
-module_exit(adp5520_keys_exit);
+module_platform_driver(adp5520_keys_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("Keys ADP5520 Driver");
diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 79172af..6df5f6a 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -259,19 +259,6 @@ static struct platform_driver amikbd_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init amikbd_init(void)
-{
-	return platform_driver_probe(&amikbd_driver, amikbd_probe);
-}
-
-module_init(amikbd_init);
-
-static void __exit amikbd_exit(void)
-{
-	platform_driver_unregister(&amikbd_driver);
-}
-
-module_exit(amikbd_exit);
+module_platform_driver(amikbd_driver);
 
 MODULE_ALIAS("platform:amiga-keyboard");
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 7d98960..683e314 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -394,19 +394,7 @@ struct platform_driver bfin_kpad_device_driver = {
 	.suspend	= bfin_kpad_suspend,
 	.resume		= bfin_kpad_resume,
 };
-
-static int __init bfin_kpad_init(void)
-{
-	return platform_driver_register(&bfin_kpad_device_driver);
-}
-
-static void __exit bfin_kpad_exit(void)
-{
-	platform_driver_unregister(&bfin_kpad_device_driver);
-}
-
-module_init(bfin_kpad_init);
-module_exit(bfin_kpad_exit);
+module_platform_driver(bfin_kpad_device_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
index 9d82b3a..4698252 100644
--- a/drivers/input/keyboard/davinci_keyscan.c
+++ b/drivers/input/keyboard/davinci_keyscan.c
@@ -328,18 +328,7 @@ static struct platform_driver davinci_ks_driver = {
 	},
 	.remove	= __devexit_p(davinci_ks_remove),
 };
-
-static int __init davinci_ks_init(void)
-{
-	return platform_driver_probe(&davinci_ks_driver, davinci_ks_probe);
-}
-module_init(davinci_ks_init);
-
-static void __exit davinci_ks_exit(void)
-{
-	platform_driver_unregister(&davinci_ks_driver);
-}
-module_exit(davinci_ks_exit);
+module_platform_driver(davinci_ks_driver);
 
 MODULE_AUTHOR("Miguel Aguilar");
 MODULE_DESCRIPTION("Texas Instruments DaVinci Key Scan Driver");
diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index 4662c5d..0ba69f3 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -390,19 +390,7 @@ static struct platform_driver ep93xx_keypad_driver = {
 	.suspend	= ep93xx_keypad_suspend,
 	.resume		= ep93xx_keypad_resume,
 };
-
-static int __init ep93xx_keypad_init(void)
-{
-	return platform_driver_register(&ep93xx_keypad_driver);
-}
-
-static void __exit ep93xx_keypad_exit(void)
-{
-	platform_driver_unregister(&ep93xx_keypad_driver);
-}
-
-module_init(ep93xx_keypad_init);
-module_exit(ep93xx_keypad_exit);
+module_platform_driver(ep93xx_keypad_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 4c17aff..20c8ab1 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -241,19 +241,7 @@ static struct platform_driver gpio_keys_polled_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init gpio_keys_polled_init(void)
-{
-	return platform_driver_register(&gpio_keys_polled_driver);
-}
-
-static void __exit gpio_keys_polled_exit(void)
-{
-	platform_driver_unregister(&gpio_keys_polled_driver);
-}
-
-module_init(gpio_keys_polled_init);
-module_exit(gpio_keys_polled_exit);
+module_platform_driver(gpio_keys_polled_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
diff --git a/drivers/input/keyboard/imx_keypad.c b/drivers/input/keyboard/imx_keypad.c
index ccebd2d..fb87b3b 100644
--- a/drivers/input/keyboard/imx_keypad.c
+++ b/drivers/input/keyboard/imx_keypad.c
@@ -619,19 +619,7 @@ static struct platform_driver imx_keypad_driver = {
 	.probe		= imx_keypad_probe,
 	.remove		= __devexit_p(imx_keypad_remove),
 };
-
-static int __init imx_keypad_init(void)
-{
-	return platform_driver_register(&imx_keypad_driver);
-}
-
-static void __exit imx_keypad_exit(void)
-{
-	platform_driver_unregister(&imx_keypad_driver);
-}
-
-module_init(imx_keypad_init);
-module_exit(imx_keypad_exit);
+module_platform_driver(imx_keypad_driver);
 
 MODULE_AUTHOR("Alberto Panizzo <maramaopercheseimorto@gmail.com>");
 MODULE_DESCRIPTION("IMX Keypad Port Driver");
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index 7197c56..24f3ea0 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -260,19 +260,7 @@ static struct platform_driver jornada680kbd_driver = {
 	.probe	= jornada680kbd_probe,
 	.remove	= __devexit_p(jornada680kbd_remove),
 };
-
-static int __init jornada680kbd_init(void)
-{
-	return platform_driver_register(&jornada680kbd_driver);
-}
-
-static void __exit jornada680kbd_exit(void)
-{
-	platform_driver_unregister(&jornada680kbd_driver);
-}
-
-module_init(jornada680kbd_init);
-module_exit(jornada680kbd_exit);
+module_platform_driver(jornada680kbd_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 620/660/680/690 Keyboard Driver");
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index 0aa6740..eeafc30 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -174,16 +174,4 @@ static struct platform_driver jornada720_kbd_driver = {
 	.probe   = jornada720_kbd_probe,
 	.remove  = __devexit_p(jornada720_kbd_remove),
 };
-
-static int __init jornada720_kbd_init(void)
-{
-	return platform_driver_register(&jornada720_kbd_driver);
-}
-
-static void __exit jornada720_kbd_exit(void)
-{
-	platform_driver_unregister(&jornada720_kbd_driver);
-}
-
-module_init(jornada720_kbd_init);
-module_exit(jornada720_kbd_exit);
+module_platform_driver(jornada720_kbd_driver);
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index e2ae657..9b223d7 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -496,19 +496,7 @@ static struct platform_driver matrix_keypad_driver = {
 #endif
 	},
 };
-
-static int __init matrix_keypad_init(void)
-{
-	return platform_driver_register(&matrix_keypad_driver);
-}
-
-static void __exit matrix_keypad_exit(void)
-{
-	platform_driver_unregister(&matrix_keypad_driver);
-}
-
-module_init(matrix_keypad_init);
-module_exit(matrix_keypad_exit);
+module_platform_driver(matrix_keypad_driver);
 
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
 MODULE_DESCRIPTION("GPIO Driven Matrix Keypad Driver");
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index fcdec5e..6c4828f 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -390,18 +390,7 @@ struct platform_driver ske_keypad_driver = {
 	.probe = ske_keypad_probe,
 	.remove = __devexit_p(ske_keypad_remove),
 };
-
-static int __init ske_keypad_init(void)
-{
-	return platform_driver_probe(&ske_keypad_driver, ske_keypad_probe);
-}
-module_init(ske_keypad_init);
-
-static void __exit ske_keypad_exit(void)
-{
-	platform_driver_unregister(&ske_keypad_driver);
-}
-module_exit(ske_keypad_exit);
+module_platform_driver(ske_keypad_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Naveen Kumar <naveen.gaddipati@stericsson.com> / Sundar Iyer <sundar.iyer@stericsson.com>");
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 323bcdf..6b630d9 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -473,20 +473,7 @@ static struct platform_driver omap_kp_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init omap_kp_init(void)
-{
-	printk(KERN_INFO "OMAP Keypad Driver\n");
-	return platform_driver_register(&omap_kp_driver);
-}
-
-static void __exit omap_kp_exit(void)
-{
-	platform_driver_unregister(&omap_kp_driver);
-}
-
-module_init(omap_kp_init);
-module_exit(omap_kp_exit);
+module_platform_driver(omap_kp_driver);
 
 MODULE_AUTHOR("Timo Teräs");
 MODULE_DESCRIPTION("OMAP Keypad Driver");
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c51a3c4..d5c5d77 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -335,18 +335,7 @@ static struct platform_driver omap4_keypad_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init omap4_keypad_init(void)
-{
-	return platform_driver_register(&omap4_keypad_driver);
-}
-module_init(omap4_keypad_init);
-
-static void __exit omap4_keypad_exit(void)
-{
-	platform_driver_unregister(&omap4_keypad_driver);
-}
-module_exit(omap4_keypad_exit);
+module_platform_driver(omap4_keypad_driver);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("OMAP4 Keypad Driver");
diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
index 1f1a556..abe728c 100644
--- a/drivers/input/keyboard/opencores-kbd.c
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -163,18 +163,7 @@ static struct platform_driver opencores_kbd_device_driver = {
 		.name = "opencores-kbd",
 	},
 };
-
-static int __init opencores_kbd_init(void)
-{
-	return platform_driver_register(&opencores_kbd_device_driver);
-}
-module_init(opencores_kbd_init);
-
-static void __exit opencores_kbd_exit(void)
-{
-	platform_driver_unregister(&opencores_kbd_device_driver);
-}
-module_exit(opencores_kbd_exit);
+module_platform_driver(opencores_kbd_device_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Javier Herrero <jherrero@hvsistemas.es>");
diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index e7cc51d..01a1c9f 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -780,18 +780,7 @@ static struct platform_driver pmic8xxx_kp_driver = {
 		.pm = &pm8xxx_kp_pm_ops,
 	},
 };
-
-static int __init pmic8xxx_kp_init(void)
-{
-	return platform_driver_register(&pmic8xxx_kp_driver);
-}
-module_init(pmic8xxx_kp_init);
-
-static void __exit pmic8xxx_kp_exit(void)
-{
-	platform_driver_unregister(&pmic8xxx_kp_driver);
-}
-module_exit(pmic8xxx_kp_exit);
+module_platform_driver(pmic8xxx_kp_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("PMIC8XXX keypad driver");
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index eca6ae6..29fe1b2 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -602,19 +602,7 @@ static struct platform_driver pxa27x_keypad_driver = {
 #endif
 	},
 };
-
-static int __init pxa27x_keypad_init(void)
-{
-	return platform_driver_register(&pxa27x_keypad_driver);
-}
-
-static void __exit pxa27x_keypad_exit(void)
-{
-	platform_driver_unregister(&pxa27x_keypad_driver);
-}
-
-module_init(pxa27x_keypad_init);
-module_exit(pxa27x_keypad_exit);
+module_platform_driver(pxa27x_keypad_driver);
 
 MODULE_DESCRIPTION("PXA27x Keypad Controller Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/keyboard/pxa930_rotary.c b/drivers/input/keyboard/pxa930_rotary.c
index 35451bf..d7f1134 100644
--- a/drivers/input/keyboard/pxa930_rotary.c
+++ b/drivers/input/keyboard/pxa930_rotary.c
@@ -195,18 +195,7 @@ static struct platform_driver pxa930_rotary_driver = {
 	.probe		= pxa930_rotary_probe,
 	.remove		= __devexit_p(pxa930_rotary_remove),
 };
-
-static int __init pxa930_rotary_init(void)
-{
-	return platform_driver_register(&pxa930_rotary_driver);
-}
-module_init(pxa930_rotary_init);
-
-static void __exit pxa930_rotary_exit(void)
-{
-	platform_driver_unregister(&pxa930_rotary_driver);
-}
-module_exit(pxa930_rotary_exit);
+module_platform_driver(pxa930_rotary_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for PXA93x Enhanced Rotary Controller");
diff --git a/drivers/input/keyboard/samsung-keypad.c b/drivers/input/keyboard/samsung-keypad.c
index f689f49..baab81d 100644
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@ -471,18 +471,7 @@ static struct platform_driver samsung_keypad_driver = {
 	},
 	.id_table	= samsung_keypad_driver_ids,
 };
-
-static int __init samsung_keypad_init(void)
-{
-	return platform_driver_register(&samsung_keypad_driver);
-}
-module_init(samsung_keypad_init);
-
-static void __exit samsung_keypad_exit(void)
-{
-	platform_driver_unregister(&samsung_keypad_driver);
-}
-module_exit(samsung_keypad_exit);
+module_platform_driver(samsung_keypad_driver);
 
 MODULE_DESCRIPTION("Samsung keypad driver");
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff --git a/drivers/input/keyboard/sh_keysc.c b/drivers/input/keyboard/sh_keysc.c
index 934aeb583..da54ad5 100644
--- a/drivers/input/keyboard/sh_keysc.c
+++ b/drivers/input/keyboard/sh_keysc.c
@@ -337,19 +337,7 @@ static struct platform_driver sh_keysc_device_driver = {
 		.pm	= &sh_keysc_dev_pm_ops,
 	}
 };
-
-static int __init sh_keysc_init(void)
-{
-	return platform_driver_register(&sh_keysc_device_driver);
-}
-
-static void __exit sh_keysc_exit(void)
-{
-	platform_driver_unregister(&sh_keysc_device_driver);
-}
-
-module_init(sh_keysc_init);
-module_exit(sh_keysc_exit);
+module_platform_driver(sh_keysc_device_driver);
 
 MODULE_AUTHOR("Magnus Damm");
 MODULE_DESCRIPTION("SuperH KEYSC Keypad Driver");
diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index d712dff..c88bd63 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -326,18 +326,7 @@ static struct platform_driver spear_kbd_driver = {
 #endif
 	},
 };
-
-static int __init spear_kbd_init(void)
-{
-	return platform_driver_register(&spear_kbd_driver);
-}
-module_init(spear_kbd_init);
-
-static void __exit spear_kbd_exit(void)
-{
-	platform_driver_unregister(&spear_kbd_driver);
-}
-module_exit(spear_kbd_exit);
+module_platform_driver(spear_kbd_driver);
 
 MODULE_AUTHOR("Rajeev Kumar");
 MODULE_DESCRIPTION("SPEAr Keyboard Driver");
diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
index ab7610c..9397cf9 100644
--- a/drivers/input/keyboard/stmpe-keypad.c
+++ b/drivers/input/keyboard/stmpe-keypad.c
@@ -368,18 +368,7 @@ static struct platform_driver stmpe_keypad_driver = {
 	.probe		= stmpe_keypad_probe,
 	.remove		= __devexit_p(stmpe_keypad_remove),
 };
-
-static int __init stmpe_keypad_init(void)
-{
-	return platform_driver_register(&stmpe_keypad_driver);
-}
-module_init(stmpe_keypad_init);
-
-static void __exit stmpe_keypad_exit(void)
-{
-	platform_driver_unregister(&stmpe_keypad_driver);
-}
-module_exit(stmpe_keypad_exit);
+module_platform_driver(stmpe_keypad_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMPExxxx keypad driver");
diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index f60c9e8..ce916fa 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -453,18 +453,7 @@ static struct platform_driver tc3589x_keypad_driver = {
 	.probe	= tc3589x_keypad_probe,
 	.remove	= __devexit_p(tc3589x_keypad_remove),
 };
-
-static int __init tc3589x_keypad_init(void)
-{
-	return platform_driver_register(&tc3589x_keypad_driver);
-}
-module_init(tc3589x_keypad_init);
-
-static void __exit tc3589x_keypad_exit(void)
-{
-	return platform_driver_unregister(&tc3589x_keypad_driver);
-}
-module_exit(tc3589x_keypad_exit);
+module_platform_driver(tc3589x_keypad_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jayeeta Banerjee/Sundar Iyer");
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index cf3228b..08d02f2 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -802,18 +802,7 @@ static struct platform_driver tegra_kbc_driver = {
 		.pm	= &tegra_kbc_pm_ops,
 	},
 };
-
-static void __exit tegra_kbc_exit(void)
-{
-	platform_driver_unregister(&tegra_kbc_driver);
-}
-module_exit(tegra_kbc_exit);
-
-static int __init tegra_kbc_init(void)
-{
-	return platform_driver_register(&tegra_kbc_driver);
-}
-module_init(tegra_kbc_init);
+module_platform_driver(tegra_kbc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rakesh Iyer <riyer@nvidia.com>");
diff --git a/drivers/input/keyboard/tnetv107x-keypad.c b/drivers/input/keyboard/tnetv107x-keypad.c
index 66e55e5..fb39c94 100644
--- a/drivers/input/keyboard/tnetv107x-keypad.c
+++ b/drivers/input/keyboard/tnetv107x-keypad.c
@@ -322,19 +322,7 @@ static struct platform_driver keypad_driver = {
 	.driver.name	= "tnetv107x-keypad",
 	.driver.owner	= THIS_MODULE,
 };
-
-static int __init keypad_init(void)
-{
-	return platform_driver_register(&keypad_driver);
-}
-
-static void __exit keypad_exit(void)
-{
-	platform_driver_unregister(&keypad_driver);
-}
-
-module_init(keypad_init);
-module_exit(keypad_exit);
+module_platform_driver(keypad_driver);
 
 MODULE_AUTHOR("Cyril Chemparathy");
 MODULE_DESCRIPTION("TNETV107X Keypad Driver");
diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index a26922c..a588578 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -460,18 +460,7 @@ static struct platform_driver twl4030_kp_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init twl4030_kp_init(void)
-{
-	return platform_driver_register(&twl4030_kp_driver);
-}
-module_init(twl4030_kp_init);
-
-static void __exit twl4030_kp_exit(void)
-{
-	platform_driver_unregister(&twl4030_kp_driver);
-}
-module_exit(twl4030_kp_exit);
+module_platform_driver(twl4030_kp_driver);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("TWL4030 Keypad Driver");
diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index 318586d..99bbb7e 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -262,19 +262,7 @@ static struct platform_driver w90p910_keypad_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init w90p910_keypad_init(void)
-{
-	return platform_driver_register(&w90p910_keypad_driver);
-}
-
-static void __exit w90p910_keypad_exit(void)
-{
-	platform_driver_unregister(&w90p910_keypad_driver);
-}
-
-module_init(w90p910_keypad_init);
-module_exit(w90p910_keypad_exit);
+module_platform_driver(w90p910_keypad_driver);
 
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("w90p910 keypad driver");
-- 
1.7.8-rc2

