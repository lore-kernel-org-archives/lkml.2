Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2GDB7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:59:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51029 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2GDB73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:59:29 -0400
Message-ID: <1341367157.10587.1.camel@phoenix>
Subject: [PATCH] regulator: tps65910: Set enable enable_time in
 regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 09:59:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 66da87c..a534e087 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -412,13 +412,6 @@ static int tps65911_get_ctrl_register(int id)
 	}
 }
 
-static int tps65910_enable_time(struct regulator_dev *dev)
-{
-	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
-	return pmic->info[id]->enable_time_us;
-}
-
 static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
@@ -762,7 +755,6 @@ static struct regulator_ops tps65910_ops_dcdc = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
-	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage_sel	= tps65910_get_voltage_dcdc_sel,
@@ -775,7 +767,6 @@ static struct regulator_ops tps65910_ops_vdd3 = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
-	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage_vdd3,
@@ -786,7 +777,6 @@ static struct regulator_ops tps65910_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
-	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage_sel	= tps65910_get_voltage_sel,
@@ -798,7 +788,6 @@ static struct regulator_ops tps65911_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
-	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage_sel	= tps65911_get_voltage_sel,
@@ -1139,6 +1128,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].name = info->name;
 		pmic->desc[i].id = i;
 		pmic->desc[i].n_voltages = info->n_voltages;
+		pmic->desc[i].enable_time = info->enable_time_us;
 
 		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
 			pmic->desc[i].ops = &tps65910_ops_dcdc;
-- 
1.7.9.5



