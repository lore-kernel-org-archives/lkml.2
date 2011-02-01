Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1BALqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:46:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57181 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752430Ab1BALqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:46:18 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Convert WM831x SPI to use dev_pm_ops
Date: Tue,  1 Feb 2011 11:46:12 +0000
Message-Id: <1296560773-14918-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a move to deprecate bus-specific PM operations and move to
using dev_pm_ops instead in order to reduce the amount of boilerplate
code in buses and facilitiate updates to the PM core. Do this move for
the WM831x SPI driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-spi.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 0a8f772..eed8e4f 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/spi/spi.h>
 
 #include <linux/mfd/wm831x/core.h>
@@ -113,22 +114,27 @@ static int __devexit wm831x_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
-static int wm831x_spi_suspend(struct spi_device *spi, pm_message_t m)
+static int wm831x_spi_suspend(struct device *dev)
 {
-	struct wm831x *wm831x = dev_get_drvdata(&spi->dev);
+	struct wm831x *wm831x = dev_get_drvdata(dev);
 
 	return wm831x_device_suspend(wm831x);
 }
 
+static const struct dev_pm_ops wm831x_spi_pm = {
+	.freeze = wm831x_spi_suspend,
+	.suspend = wm831x_spi_suspend,
+};
+
 static struct spi_driver wm8310_spi_driver = {
 	.driver = {
 		.name	= "wm8310",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static struct spi_driver wm8311_spi_driver = {
@@ -136,10 +142,10 @@ static struct spi_driver wm8311_spi_driver = {
 		.name	= "wm8311",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static struct spi_driver wm8312_spi_driver = {
@@ -147,10 +153,10 @@ static struct spi_driver wm8312_spi_driver = {
 		.name	= "wm8312",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static struct spi_driver wm8320_spi_driver = {
@@ -158,10 +164,10 @@ static struct spi_driver wm8320_spi_driver = {
 		.name	= "wm8320",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static struct spi_driver wm8321_spi_driver = {
@@ -169,10 +175,10 @@ static struct spi_driver wm8321_spi_driver = {
 		.name	= "wm8321",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static struct spi_driver wm8325_spi_driver = {
@@ -180,10 +186,10 @@ static struct spi_driver wm8325_spi_driver = {
 		.name	= "wm8325",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static struct spi_driver wm8326_spi_driver = {
@@ -191,10 +197,10 @@ static struct spi_driver wm8326_spi_driver = {
 		.name	= "wm8326",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
-	.suspend	= wm831x_spi_suspend,
 };
 
 static int __init wm831x_spi_init(void)
-- 
1.7.2.3

