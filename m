Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1CRMnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:43:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52828 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800Ab1CRMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:43:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Remove more wm831x-specific IRQ operations
Date: Fri, 18 Mar 2011 12:43:35 +0000
Message-Id: <1300452215-30119-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the last users in the tree.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 857d741..e93453b 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -604,8 +604,8 @@ static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "HC"), dcdc);
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(platform_get_irq_byname(pdev, "HC"), dcdc);
+	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 	if (dcdc->dvs_gpio)
 		gpio_free(dcdc->dvs_gpio);
@@ -780,7 +780,7 @@ static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 	kfree(dcdc);
 
-- 
1.7.4.1

