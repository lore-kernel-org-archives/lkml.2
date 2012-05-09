Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370Ab2EIXtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:49:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57019 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761273Ab2EIXtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:49:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm831x: Register all normal regulators
Date: Thu, 10 May 2012 00:49:14 +0100
Message-Id: <1336607354-5071-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register all normal regulators rather than skipping unconfigured ones now
that the core can handle regulators without init data. Skip the boost and
isink regulators since they are normally controlled by other drivers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   18 ++++++------------
 drivers/regulator/wm831x-ldo.c  |   18 ++++++------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 13c71c6..8710cfb 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -472,9 +472,6 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
-	if (pdata == NULL || pdata->dcdc[id] == NULL)
-		return -ENODEV;
-
 	dcdc = devm_kzalloc(&pdev->dev,  sizeof(struct wm831x_dcdc),
 			    GFP_KERNEL);
 	if (dcdc == NULL) {
@@ -525,7 +522,8 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 		wm831x_buckv_dvs_init(dcdc, pdata->dcdc[id]->driver_data);
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->dcdc[id];
+	if (pdata)
+		config.init_data = pdata->dcdc[id];
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
@@ -680,9 +678,6 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
-	if (pdata == NULL || pdata->dcdc[id] == NULL)
-		return -ENODEV;
-
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc),
 			    GFP_KERNEL);
 	if (dcdc == NULL) {
@@ -718,7 +713,8 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	dcdc->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->dcdc[id];
+	if (pdata)
+		config.init_data = pdata->dcdc[id];
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
@@ -930,9 +926,6 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "Probing EPE%d\n", id + 1);
 
-	if (pdata == NULL || pdata->epe[id] == NULL)
-		return -ENODEV;
-
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
 	if (dcdc == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
@@ -954,7 +947,8 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 	dcdc->desc.enable_mask = 1 << dcdc->desc.id;
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->epe[id];
+	if (pdata)
+		config.init_data = pdata->epe[id];
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 74ee686..aa1f8b3 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -274,9 +274,6 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
-	if (pdata == NULL || pdata->ldo[id] == NULL)
-		return -ENODEV;
-
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
@@ -311,7 +308,8 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	ldo->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->ldo[id];
+	if (pdata)
+		config.init_data = pdata->ldo[id];
 	config.driver_data = ldo;
 	config.regmap = wm831x->regmap;
 
@@ -537,9 +535,6 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
-	if (pdata == NULL || pdata->ldo[id] == NULL)
-		return -ENODEV;
-
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
@@ -574,7 +569,8 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	ldo->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->ldo[id];
+	if (pdata)
+		config.init_data = pdata->ldo[id];
 	config.driver_data = ldo;
 	config.regmap = wm831x->regmap;
 
@@ -721,9 +717,6 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
-	if (pdata == NULL || pdata->ldo[id] == NULL)
-		return -ENODEV;
-
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
@@ -760,7 +753,8 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.uV_step = 50000;
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->ldo[id];
+	if (pdata)
+		config.init_data = pdata->ldo[id];
 	config.driver_data = ldo;
 	config.regmap = wm831x->regmap;
 
-- 
1.7.10

