Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab2CUUL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:11:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35236 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758419Ab2CUUL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:11:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: fixed: Use devm_kzalloc()
Date: Wed, 21 Mar 2012 20:11:22 +0000
Message-Id: <1332360683-26231-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 40f3803..7d4f381 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -176,7 +176,8 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	if (!config)
 		return -ENOMEM;
 
-	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
+			       GFP_KERNEL);
 	if (drvdata == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate device data\n");
 		ret = -ENOMEM;
@@ -270,7 +271,6 @@ err_gpio:
 err_name:
 	kfree(drvdata->desc.name);
 err:
-	kfree(drvdata);
 	return ret;
 }
 
@@ -282,7 +282,6 @@ static int __devexit reg_fixed_voltage_remove(struct platform_device *pdev)
 	if (gpio_is_valid(drvdata->gpio))
 		gpio_free(drvdata->gpio);
 	kfree(drvdata->desc.name);
-	kfree(drvdata);
 
 	return 0;
 }
-- 
1.7.9.1

