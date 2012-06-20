Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2FTOz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:55:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33710 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2FTOz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:55:57 -0400
Message-ID: <1340204150.8003.8.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Convert to
 regulator_set_voltage_time_sel()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 20 Jun 2012 22:55:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index d044a58..d5b02fc 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -76,7 +76,6 @@ struct tps62360_chip {
 	int lru_index[4];
 	int curr_vset_vsel[4];
 	int curr_vset_id;
-	int change_uv_per_us;
 };
 
 /*
@@ -175,16 +174,6 @@ static int tps62360_dcdc_set_voltage_sel(struct regulator_dev *dev,
 	return 0;
 }
 
-static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
-		unsigned int old_selector, unsigned int new_selector)
-{
-	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
-
-	return DIV_ROUND_UP(abs(new_selector - old_selector) *
-			    rdev->desc->uV_step,
-			    tps->change_uv_per_us);
-}
-
 static int tps62360_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
@@ -251,7 +240,7 @@ static struct regulator_ops tps62360_dcdc_ops = {
 	.set_voltage_sel	= tps62360_dcdc_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
-	.set_voltage_time_sel	= tps62360_set_voltage_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_mode		= tps62360_set_mode,
 	.get_mode		= tps62360_get_mode,
 };
@@ -294,7 +283,7 @@ static int __devinit tps62360_init_dcdc(struct tps62360_chip *tps,
 	ramp_ctrl = (ramp_ctrl >> 4) & 0x7;
 
 	/* ramp mV/us = 32/(2^ramp_ctrl) */
-	tps->change_uv_per_us = DIV_ROUND_UP(32000, BIT(ramp_ctrl));
+	tps->desc.ramp_delay = DIV_ROUND_UP(32000, BIT(ramp_ctrl));
 	return ret;
 }
 
-- 
1.7.9.5



