Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2EHRQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:16:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33774 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757640Ab2EHRQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:16:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm8994: Use main I2C device as struct device
Date: Tue,  8 May 2012 18:15:58 +0100
Message-Id: <1336497358-8285-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes logging a bit clearer as it gives the actual bus location and
makes things like board hookup a bit smoother.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 739207b..7c64ce5 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -191,7 +191,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	} else
 		ldo->is_enabled = true;
 
-	config.dev = &pdev->dev;
+	config.dev = wm8994->dev;
 	config.init_data = pdata->ldo[id].init_data;
 	config.driver_data = ldo;
 	config.regmap = wm8994->regmap;
-- 
1.7.10

