Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2EGRTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:19:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38216 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757467Ab2EGRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:19:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: wm8994: Convert to gpio_request_one()
Date: Mon,  7 May 2012 18:19:41 +0100
Message-Id: <1336411182-13466-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index e07972f..739207b 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -182,19 +182,12 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
 		ldo->enable = pdata->ldo[id].enable;
 
-		ret = gpio_request(ldo->enable, "WM8994 LDO enable");
+		ret = gpio_request_one(ldo->enable, 0, "WM8994 LDO enable");
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Failed to get enable GPIO: %d\n",
 				ret);
 			goto err;
 		}
-
-		ret = gpio_direction_output(ldo->enable, ldo->is_enabled);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "Failed to set GPIO up: %d\n",
-				ret);
-			goto err_gpio;
-		}
 	} else
 		ldo->is_enabled = true;
 
-- 
1.7.10

