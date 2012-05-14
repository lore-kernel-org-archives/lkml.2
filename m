Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2ENKku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:40:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51354 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755275Ab2ENKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:40:49 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm831x-dcdc: Add missing checks for pdata before use
Date: Mon, 14 May 2012 11:40:46 +0100
Message-Id: <1336992046-20007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index d685911..099da11 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -518,7 +518,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 	dcdc->dvs_vsel = ret & WM831X_DC1_DVS_VSEL_MASK;
 
-	if (pdata->dcdc[id])
+	if (pdata && pdata->dcdc[id])
 		wm831x_buckv_dvs_init(dcdc, pdata->dcdc[id]->driver_data);
 
 	config.dev = pdev->dev.parent;
@@ -851,7 +851,8 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	dcdc->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
-	config.init_data = pdata->dcdc[id];
+	if (pdata)
+		config.init_data = pdata->dcdc[id];
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
-- 
1.7.10

