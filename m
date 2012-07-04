Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab2GDCDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:03:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40338 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2GDCDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:03:30 -0400
Message-ID: <1341367403.10587.3.camel@phoenix>
Subject: [PATCH] regulator: ab3100: Set enable enable_time in regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 10:03:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 16d420b..5f771a8 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -347,31 +347,6 @@ static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
 	return abreg->plfdata->external_voltage;
 }
 
-static int ab3100_enable_time_regulator(struct regulator_dev *reg)
-{
-	struct ab3100_regulator *abreg = reg->reg_data;
-
-	/* Per-regulator power on delay from spec */
-	switch (abreg->regreg) {
-	case AB3100_LDO_A: /* Fallthrough */
-	case AB3100_LDO_C: /* Fallthrough */
-	case AB3100_LDO_D: /* Fallthrough */
-	case AB3100_LDO_E: /* Fallthrough */
-	case AB3100_LDO_H: /* Fallthrough */
-	case AB3100_LDO_K:
-		return 200;
-	case AB3100_LDO_F:
-		return 600;
-	case AB3100_LDO_G:
-		return 400;
-	case AB3100_BUCK:
-		return 1000;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static int ab3100_get_fixed_voltage_regulator(struct regulator_dev *reg)
 {
 	return reg->desc->min_uV;
@@ -383,7 +358,6 @@ static struct regulator_ops regulator_ops_fixed = {
 	.disable     = ab3100_disable_regulator,
 	.is_enabled  = ab3100_is_enabled_regulator,
 	.get_voltage = ab3100_get_fixed_voltage_regulator,
-	.enable_time = ab3100_enable_time_regulator,
 };
 
 static struct regulator_ops regulator_ops_variable = {
@@ -393,7 +367,6 @@ static struct regulator_ops regulator_ops_variable = {
 	.get_voltage = ab3100_get_voltage_regulator,
 	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
 	.list_voltage = regulator_list_voltage_table,
-	.enable_time = ab3100_enable_time_regulator,
 };
 
 static struct regulator_ops regulator_ops_variable_sleepable = {
@@ -404,7 +377,6 @@ static struct regulator_ops regulator_ops_variable_sleepable = {
 	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
 	.set_suspend_voltage = ab3100_set_suspend_voltage_regulator,
 	.list_voltage = regulator_list_voltage_table,
-	.enable_time = ab3100_enable_time_regulator,
 };
 
 /*
@@ -430,6 +402,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.min_uV = LDO_A_VOLTAGE,
+		.enable_time = 200,
 	},
 	{
 		.name = "LDO_C",
@@ -439,6 +412,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.min_uV = LDO_C_VOLTAGE,
+		.enable_time = 200,
 	},
 	{
 		.name = "LDO_D",
@@ -448,6 +422,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.min_uV = LDO_D_VOLTAGE,
+		.enable_time = 200,
 	},
 	{
 		.name = "LDO_E",
@@ -457,6 +432,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.volt_table = ldo_e_buck_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.enable_time = 200,
 	},
 	{
 		.name = "LDO_F",
@@ -466,6 +442,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.volt_table = ldo_f_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.enable_time = 600,
 	},
 	{
 		.name = "LDO_G",
@@ -475,6 +452,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.volt_table = ldo_g_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.enable_time = 400,
 	},
 	{
 		.name = "LDO_H",
@@ -484,6 +462,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.volt_table = ldo_h_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.enable_time = 200,
 	},
 	{
 		.name = "LDO_K",
@@ -493,6 +472,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.volt_table = ldo_k_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.enable_time = 200,
 	},
 	{
 		.name = "LDO_EXT",
@@ -508,6 +488,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.enable_time = 1000,
 	},
 };
 
-- 
1.7.9.5



