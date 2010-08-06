Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479Ab0HFOsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:48:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40398 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754948Ab0HFOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:48:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH] regulator: Default GPIO controlled WM8994 regulators to disabled
Date: Fri,  6 Aug 2010 15:48:24 +0100
Message-Id: <1281106104-6079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonyoung Shim <jy0922.shim@samsung.com>

This ensures that if the GPIO was not enabled prior to the driver
starting the regulator API will insert the required powerup ramp
delay when it enables the regulator.  The gpiolib API does not
provide this information.

[Rewrote changelog to describe the actual change -- broonie.]

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/regulator/wm8994-regulator.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 5a1dc8a..03713bc 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -219,8 +219,6 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 
 	ldo->wm8994 = wm8994;
 
-	ldo->is_enabled = true;
-
 	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
 		ldo->enable = pdata->ldo[id].enable;
 
@@ -237,7 +235,8 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 				ret);
 			goto err_gpio;
 		}
-	}
+	} else
+		ldo->is_enabled = true;
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
 					     pdata->ldo[id].init_data, ldo);
-- 
1.7.1

