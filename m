Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2F0OKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:10:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57105 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624Ab2F0OKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:10:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regulator: wm8994: Set enable_time in descriptor
Date: Wed, 27 Jun 2012 15:10:11 +0100
Message-Id: <1340806212-30457-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 0e2028b..7a1fd77 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -70,18 +70,10 @@ static int wm8994_ldo_is_enabled(struct regulator_dev *rdev)
 	return ldo->is_enabled;
 }
 
-static int wm8994_ldo_enable_time(struct regulator_dev *rdev)
-{
-	/* 3ms is fairly conservative but this shouldn't be too performance
-	 * critical; can be tweaked per-system if required. */
-	return 3000;
-}
-
 static struct regulator_ops wm8994_ldo1_ops = {
 	.enable = wm8994_ldo_enable,
 	.disable = wm8994_ldo_disable,
 	.is_enabled = wm8994_ldo_is_enabled,
-	.enable_time = wm8994_ldo_enable_time,
 
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
@@ -137,6 +129,7 @@ static const struct regulator_desc wm8994_ldo_desc[] = {
 		.ops = &wm8994_ldo1_ops,
 		.min_uV = 2400000,
 		.uV_step = 100000,
+		.enable_time = 3000,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -147,6 +140,7 @@ static const struct regulator_desc wm8994_ldo_desc[] = {
 		.vsel_reg = WM8994_LDO_2,
 		.vsel_mask = WM8994_LDO2_VSEL_MASK,
 		.ops = &wm8994_ldo2_ops,
+		.enable_time = 3000,
 		.owner = THIS_MODULE,
 	},
 };
-- 
1.7.10

