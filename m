Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2CWJAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:00:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58087 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2CWJAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:00:07 -0400
Message-ID: <1332493201.27981.5.camel@phoenix>
Subject: [PATCH] regulator: wm831x-dcdc: Use devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 17:00:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 4904a40..909c53b 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -848,7 +848,7 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->dcdc[id] == NULL)
 		return -ENODEV;
 
-	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
 	if (dcdc == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -897,7 +897,6 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
-	kfree(dcdc);
 	return ret;
 }
 
@@ -909,7 +908,6 @@ static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
 
 	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
-	kfree(dcdc);
 
 	return 0;
 }
@@ -952,7 +950,7 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 	if (pdata == NULL || pdata->epe[id] == NULL)
 		return -ENODEV;
 
-	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
 	if (dcdc == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -984,7 +982,6 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	kfree(dcdc);
 	return ret;
 }
 
@@ -993,9 +990,7 @@ static __devexit int wm831x_epe_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
-
 	regulator_unregister(dcdc->regulator);
-	kfree(dcdc);
 
 	return 0;
 }
-- 
1.7.5.4



