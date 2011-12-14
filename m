Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab1LNSU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:20:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42723 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757368Ab1LNSUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:20:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Convert wm831x regulator drivers to devm_kzalloc()
Date: Thu, 15 Dec 2011 02:20:10 +0800
Message-Id: <1323886810-8047-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c  |   10 ++++------
 drivers/regulator/wm831x-isink.c |    5 ++---
 drivers/regulator/wm831x-ldo.c   |   12 +++---------
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 7558a96..4904a40 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -511,7 +511,8 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->dcdc[id] == NULL)
 		return -ENODEV;
 
-	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	dcdc = devm_kzalloc(&pdev->dev,  sizeof(struct wm831x_dcdc),
+			    GFP_KERNEL);
 	if (dcdc == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -590,7 +591,6 @@ err_regulator:
 err:
 	if (dcdc->dvs_gpio)
 		gpio_free(dcdc->dvs_gpio);
-	kfree(dcdc);
 	return ret;
 }
 
@@ -605,7 +605,6 @@ static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 	regulator_unregister(dcdc->regulator);
 	if (dcdc->dvs_gpio)
 		gpio_free(dcdc->dvs_gpio);
-	kfree(dcdc);
 
 	return 0;
 }
@@ -722,7 +721,8 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->dcdc[id] == NULL)
 		return -ENODEV;
 
-	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc),
+			    GFP_KERNEL);
 	if (dcdc == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -771,7 +771,6 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
-	kfree(dcdc);
 	return ret;
 }
 
@@ -783,7 +782,6 @@ static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 
 	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
-	kfree(dcdc);
 
 	return 0;
 }
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index d3ad3f5..634aac3 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -162,7 +162,8 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->isink[id] == NULL)
 		return -ENODEV;
 
-	isink = kzalloc(sizeof(struct wm831x_isink), GFP_KERNEL);
+	isink = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_isink),
+			     GFP_KERNEL);
 	if (isink == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -213,7 +214,6 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 err_regulator:
 	regulator_unregister(isink->regulator);
 err:
-	kfree(isink);
 	return ret;
 }
 
@@ -226,7 +226,6 @@ static __devexit int wm831x_isink_remove(struct platform_device *pdev)
 	free_irq(platform_get_irq(pdev, 0), isink);
 
 	regulator_unregister(isink->regulator);
-	kfree(isink);
 
 	return 0;
 }
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 5e96a23..f1e4ab0 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -326,7 +326,7 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->ldo[id] == NULL)
 		return -ENODEV;
 
-	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
+	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -376,7 +376,6 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 err_regulator:
 	regulator_unregister(ldo->regulator);
 err:
-	kfree(ldo);
 	return ret;
 }
 
@@ -388,7 +387,6 @@ static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
 
 	free_irq(platform_get_irq_byname(pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
-	kfree(ldo);
 
 	return 0;
 }
@@ -596,7 +594,7 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->ldo[id] == NULL)
 		return -ENODEV;
 
-	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
+	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -645,7 +643,6 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 err_regulator:
 	regulator_unregister(ldo->regulator);
 err:
-	kfree(ldo);
 	return ret;
 }
 
@@ -655,7 +652,6 @@ static __devexit int wm831x_aldo_remove(struct platform_device *pdev)
 
 	free_irq(platform_get_irq_byname(pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
-	kfree(ldo);
 
 	return 0;
 }
@@ -793,7 +789,7 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->ldo[id] == NULL)
 		return -ENODEV;
 
-	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
+	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -831,7 +827,6 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	kfree(ldo);
 	return ret;
 }
 
@@ -840,7 +835,6 @@ static __devexit int wm831x_alive_ldo_remove(struct platform_device *pdev)
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
 	regulator_unregister(ldo->regulator);
-	kfree(ldo);
 
 	return 0;
 }
-- 
1.7.7.3

