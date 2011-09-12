Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab1ILPpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:45:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56277 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab1ILPpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:45:12 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] wm831x-spi: use id_table rather hand rolled variant handling
Date: Mon, 12 Sep 2011 17:45:02 +0200
Message-Id: <1315842302-27607-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi subsystem supports device tables nowadays, so use it.

Only build tested as I don't have the hw.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/mfd/wm831x-spi.c |  138 ++++++----------------------------------------
 1 files changed, 17 insertions(+), 121 deletions(-)

diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index eed8e4f..2387247 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -69,22 +69,8 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 	struct wm831x *wm831x;
 	enum wm831x_parent type;
 
-	/* Currently SPI support for ID tables is unmerged, we're faking it */
-	if (strcmp(spi->modalias, "wm8310") == 0)
-		type = WM8310;
-	else if (strcmp(spi->modalias, "wm8311") == 0)
-		type = WM8311;
-	else if (strcmp(spi->modalias, "wm8312") == 0)
-		type = WM8312;
-	else if (strcmp(spi->modalias, "wm8320") == 0)
-		type = WM8320;
-	else if (strcmp(spi->modalias, "wm8321") == 0)
-		type = WM8321;
-	else if (strcmp(spi->modalias, "wm8325") == 0)
-		type = WM8325;
-	else if (strcmp(spi->modalias, "wm8326") == 0)
-		type = WM8326;
-	else {
+	type = spi_get_device_id(spi)->driver_data;
+	if (!type) {
 		dev_err(&spi->dev, "Unknown device type\n");
 		return -EINVAL;
 	}
@@ -126,128 +112,38 @@ static const struct dev_pm_ops wm831x_spi_pm = {
 	.suspend = wm831x_spi_suspend,
 };
 
-static struct spi_driver wm8310_spi_driver = {
-	.driver = {
-		.name	= "wm8310",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8311_spi_driver = {
-	.driver = {
-		.name	= "wm8311",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
+static const struct spi_device_id wm831x_ids[] = {
+	{ "wm8310", WM8310 },
+	{ "wm8311", WM8311 },
+	{ "wm8312", WM8312 },
+	{ "wm8320", WM8320 },
+	{ "wm8321", WM8321 },
+	{ "wm8325", WM8325 },
+	{ "wm8326", WM8326 },
+	{ },
 };
+MODULE_DEVICE_TABLE(spi, wm831x_ids);
 
-static struct spi_driver wm8312_spi_driver = {
+static struct spi_driver wm831x_spi_driver = {
 	.driver = {
-		.name	= "wm8312",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8320_spi_driver = {
-	.driver = {
-		.name	= "wm8320",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8321_spi_driver = {
-	.driver = {
-		.name	= "wm8321",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8325_spi_driver = {
-	.driver = {
-		.name	= "wm8325",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8326_spi_driver = {
-	.driver = {
-		.name	= "wm8326",
-		.bus	= &spi_bus_type,
+		.name	= "wm831x",
 		.owner	= THIS_MODULE,
 		.pm	= &wm831x_spi_pm,
 	},
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
+	.id_table	= wm831x_ids,
 };
 
 static int __init wm831x_spi_init(void)
 {
-	int ret;
-
-	ret = spi_register_driver(&wm8310_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8310 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8311_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8311 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8312_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8312 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8320_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8320 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8321_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8321 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8325_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8325 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8326_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8326 SPI driver: %d\n", ret);
-
-	return 0;
+	return spi_register_driver(&wm831x_spi_driver);
 }
 subsys_initcall(wm831x_spi_init);
 
 static void __exit wm831x_spi_exit(void)
 {
-	spi_unregister_driver(&wm8326_spi_driver);
-	spi_unregister_driver(&wm8325_spi_driver);
-	spi_unregister_driver(&wm8321_spi_driver);
-	spi_unregister_driver(&wm8320_spi_driver);
-	spi_unregister_driver(&wm8312_spi_driver);
-	spi_unregister_driver(&wm8311_spi_driver);
-	spi_unregister_driver(&wm8310_spi_driver);
+	spi_unregister_driver(&wm831x_spi_driver);
 }
 module_exit(wm831x_spi_exit);
 
-- 
1.7.5.4

