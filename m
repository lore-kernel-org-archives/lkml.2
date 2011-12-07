Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1LGQb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:31:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39727 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757764Ab1LGQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] gpio: Convert GPIO drivers to module_platform_driver
Date: Thu,  8 Dec 2011 00:24:00 +0800
Message-Id: <1323275041-25493-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where appropriate factor out some boilerplate code for platform device
registration into module_platform_driver. Drivers that don't use the
standard module_init initcall haven't been converted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-adp5520.c    |   12 +-----------
 drivers/gpio/gpio-cs5535.c     |   13 +------------
 drivers/gpio/gpio-da9052.c     |   12 +-----------
 drivers/gpio/gpio-generic.c    |   12 +-----------
 drivers/gpio/gpio-janz-ttl.c   |   13 +------------
 drivers/gpio/gpio-rdc321x.c    |   13 +------------
 drivers/gpio/gpio-sch.c        |   13 +------------
 drivers/gpio/gpio-timberdale.c |   13 +------------
 drivers/gpio/gpio-ucb1400.c    |   13 +------------
 drivers/gpio/gpio-vr41xx.c     |   13 +------------
 drivers/gpio/gpio-vx855.c      |   12 +-----------
 11 files changed, 11 insertions(+), 128 deletions(-)

diff --git a/drivers/gpio/gpio-adp5520.c b/drivers/gpio/gpio-adp5520.c
index 9f27815..2f263cc 100644
--- a/drivers/gpio/gpio-adp5520.c
+++ b/drivers/gpio/gpio-adp5520.c
@@ -193,17 +193,7 @@ static struct platform_driver adp5520_gpio_driver = {
 	.remove		= __devexit_p(adp5520_gpio_remove),
 };
 
-static int __init adp5520_gpio_init(void)
-{
-	return platform_driver_register(&adp5520_gpio_driver);
-}
-module_init(adp5520_gpio_init);
-
-static void __exit adp5520_gpio_exit(void)
-{
-	platform_driver_unregister(&adp5520_gpio_driver);
-}
-module_exit(adp5520_gpio_exit);
+module_platform_driver(adp5520_gpio_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("GPIO ADP5520 Driver");
diff --git a/drivers/gpio/gpio-cs5535.c b/drivers/gpio/gpio-cs5535.c
index 6e16cba..a6403a0 100644
--- a/drivers/gpio/gpio-cs5535.c
+++ b/drivers/gpio/gpio-cs5535.c
@@ -382,18 +382,7 @@ static struct platform_driver cs5535_gpio_driver = {
 	.remove = __devexit_p(cs5535_gpio_remove),
 };
 
-static int __init cs5535_gpio_init(void)
-{
-	return platform_driver_register(&cs5535_gpio_driver);
-}
-
-static void __exit cs5535_gpio_exit(void)
-{
-	platform_driver_unregister(&cs5535_gpio_driver);
-}
-
-module_init(cs5535_gpio_init);
-module_exit(cs5535_gpio_exit);
+module_platform_driver(cs5535_gpio_driver);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
index 038f5eb..58ac377 100644
--- a/drivers/gpio/gpio-da9052.c
+++ b/drivers/gpio/gpio-da9052.c
@@ -259,17 +259,7 @@ static struct platform_driver da9052_gpio_driver = {
 	},
 };
 
-static int __init da9052_gpio_init(void)
-{
-	return platform_driver_register(&da9052_gpio_driver);
-}
-module_init(da9052_gpio_init);
-
-static void __exit da9052_gpio_exit(void)
-{
-	return platform_driver_unregister(&da9052_gpio_driver);
-}
-module_exit(da9052_gpio_exit);
+module_platform_driver(da9052_gpio_driver);
 
 MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
 MODULE_DESCRIPTION("DA9052 GPIO Device Driver");
diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 4e24436..e38dd0c 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -524,17 +524,7 @@ static struct platform_driver bgpio_driver = {
 	.remove = __devexit_p(bgpio_pdev_remove),
 };
 
-static int __init bgpio_platform_init(void)
-{
-	return platform_driver_register(&bgpio_driver);
-}
-module_init(bgpio_platform_init);
-
-static void __exit bgpio_platform_exit(void)
-{
-	platform_driver_unregister(&bgpio_driver);
-}
-module_exit(bgpio_platform_exit);
+module_platform_driver(bgpio_driver);
 
 #endif /* CONFIG_GPIO_GENERIC_PLATFORM */
 
diff --git a/drivers/gpio/gpio-janz-ttl.c b/drivers/gpio/gpio-janz-ttl.c
index 813ac07..9ec698e 100644
--- a/drivers/gpio/gpio-janz-ttl.c
+++ b/drivers/gpio/gpio-janz-ttl.c
@@ -239,20 +239,9 @@ static struct platform_driver ttl_driver = {
 	.remove		= __devexit_p(ttl_remove),
 };
 
-static int __init ttl_init(void)
-{
-	return platform_driver_register(&ttl_driver);
-}
-
-static void __exit ttl_exit(void)
-{
-	platform_driver_unregister(&ttl_driver);
-}
+module_platform_driver(ttl_driver);
 
 MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
 MODULE_DESCRIPTION("Janz MODULbus VMOD-TTL Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:janz-ttl");
-
-module_init(ttl_init);
-module_exit(ttl_exit);
diff --git a/drivers/gpio/gpio-rdc321x.c b/drivers/gpio/gpio-rdc321x.c
index 2762698..e97016a 100644
--- a/drivers/gpio/gpio-rdc321x.c
+++ b/drivers/gpio/gpio-rdc321x.c
@@ -227,18 +227,7 @@ static struct platform_driver rdc321x_gpio_driver = {
 	.remove		= __devexit_p(rdc321x_gpio_remove),
 };
 
-static int __init rdc321x_gpio_init(void)
-{
-	return platform_driver_register(&rdc321x_gpio_driver);
-}
-
-static void __exit rdc321x_gpio_exit(void)
-{
-	platform_driver_unregister(&rdc321x_gpio_driver);
-}
-
-module_init(rdc321x_gpio_init);
-module_exit(rdc321x_gpio_exit);
+module_platform_driver(rdc321x_gpio_driver);
 
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION("RDC321x GPIO driver");
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 1635158..8cadf4d 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -297,18 +297,7 @@ static struct platform_driver sch_gpio_driver = {
 	.remove		= __devexit_p(sch_gpio_remove),
 };
 
-static int __init sch_gpio_init(void)
-{
-	return platform_driver_register(&sch_gpio_driver);
-}
-
-static void __exit sch_gpio_exit(void)
-{
-	platform_driver_unregister(&sch_gpio_driver);
-}
-
-module_init(sch_gpio_init);
-module_exit(sch_gpio_exit);
+module_platform_driver(sch_gpio_driver);
 
 MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
 MODULE_DESCRIPTION("GPIO interface for Intel Poulsbo SCH");
diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index c593bd4..031c6ad 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -359,18 +359,7 @@ static struct platform_driver timbgpio_platform_driver = {
 
 /*--------------------------------------------------------------------------*/
 
-static int __init timbgpio_init(void)
-{
-	return platform_driver_register(&timbgpio_platform_driver);
-}
-
-static void __exit timbgpio_exit(void)
-{
-	platform_driver_unregister(&timbgpio_platform_driver);
-}
-
-module_init(timbgpio_init);
-module_exit(timbgpio_exit);
+module_platform_driver(timbgpio_platform_driver);
 
 MODULE_DESCRIPTION("Timberdale GPIO driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/gpio/gpio-ucb1400.c b/drivers/gpio/gpio-ucb1400.c
index 50e6bd1..26405ef 100644
--- a/drivers/gpio/gpio-ucb1400.c
+++ b/drivers/gpio/gpio-ucb1400.c
@@ -103,23 +103,12 @@ static struct platform_driver ucb1400_gpio_driver = {
 	},
 };
 
-static int __init ucb1400_gpio_init(void)
-{
-	return platform_driver_register(&ucb1400_gpio_driver);
-}
-
-static void __exit ucb1400_gpio_exit(void)
-{
-	platform_driver_unregister(&ucb1400_gpio_driver);
-}
-
 void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data)
 {
 	ucbdata = data;
 }
 
-module_init(ucb1400_gpio_init);
-module_exit(ucb1400_gpio_exit);
+module_platform_driver(ucb1400_gpio_driver);
 
 MODULE_DESCRIPTION("Philips UCB1400 GPIO driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index 98723cb..82d5c20 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -571,15 +571,4 @@ static struct platform_driver giu_device_driver = {
 	},
 };
 
-static int __init vr41xx_giu_init(void)
-{
-	return platform_driver_register(&giu_device_driver);
-}
-
-static void __exit vr41xx_giu_exit(void)
-{
-	platform_driver_unregister(&giu_device_driver);
-}
-
-module_init(vr41xx_giu_init);
-module_exit(vr41xx_giu_exit);
+module_platform_driver(giu_device_driver);
diff --git a/drivers/gpio/gpio-vx855.c b/drivers/gpio/gpio-vx855.c
index ef5aabd..76ebfe5 100644
--- a/drivers/gpio/gpio-vx855.c
+++ b/drivers/gpio/gpio-vx855.c
@@ -315,17 +315,7 @@ static struct platform_driver vx855gpio_driver = {
 	.remove		= __devexit_p(vx855gpio_remove),
 };
 
-static int vx855gpio_init(void)
-{
-	return platform_driver_register(&vx855gpio_driver);
-}
-module_init(vx855gpio_init);
-
-static void vx855gpio_exit(void)
-{
-	platform_driver_unregister(&vx855gpio_driver);
-}
-module_exit(vx855gpio_exit);
+module_platform_driver(vx855gpio_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
-- 
1.7.7.3

