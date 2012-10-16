Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2JPL7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:59:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17932 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2JPL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:59:42 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-4a-507d4c2cce4f
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2 1/2] regulator: max77686: Use already set opmode while
 re-enabling regulators.
Date: Tue, 16 Oct 2012 17:24:18 +0530
Message-id: <1350388459-28975-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWyRsSkTlfHpzbAYG2flsXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr4Mm8He8EH4YqbN7czNTC+EOhi5OSQEDCRuLl+EQuELSZx4d56
	ti5GLg4hgaWMEie7r7HAFF3dPYkdIjGdUeJU90MoZzmTxJ3HF1m7GDk42ASMJF4dswNpEBFQ
	kNjc+4wVpIZZ4A6TxP5LjUwgCWGBZIkLuzeBTWURUJVYtu0kK4jNK+Aqcfb1PKhtChKtyw6x
	Q9QISHybfIgFZL6EgKzEpgPMIDMlBA6wSWyfsxSqXlLi4IobLBMYBRcwMqxiFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECAyq0/+eSe9gXNVgcYhRgINRiYc3w7kmQIg1say4MvcQowQHs5II
	r6ptbYAQb0piZVVqUX58UWlOavEhRh+gSyYyS4km5wMDPq8k3tDYxNzU2NTSyMjM1BSHsJI4
	b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRiGf793rzaMm7iw+3aP3qT3sW3b4lq9z/qkEVywv
	cbaxn24j+fGKzR3RvB3GLS763OY53+NifPJnXqx6tGGTlWaPgcMWxd/iv49ZSeyx1Ux+ncGd
	8mmdsxbP32c/U1aum3Q8sXJj9AG5ST9rH3acv7ZoeUufTdzHX0XB9w8cyZwdrhnVMFmXQYml
	OCPRUIu5qDgRACvR0yxXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQV0dn9oAg6bjihaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx48u8HewFH4Qrbt7cztTA
	+EKgi5GTQ0LAROLq7knsELaYxIV769m6GLk4hASmM0qc6n7IDuEsZ5K48/giaxcjBwebgJHE
	q2N2IA0iAgoSm3ufsYLUMAvcYZLYf6mRCSQhLJAscWH3JhYQm0VAVWLZtpOsIDavgKvE2dfz
	WCC2KUi0LjvEPoGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4JB9Jr2DcVWDxSFG
	AQ5GJR7eDOeaACHWxLLiytxDjBIczEoivKq2tQFCvCmJlVWpRfnxRaU5qcWHGH2Atk9klhJN
	zgfGU15JvKGxibmpsamliYWJmSUOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjOFfXWJV
	gj/su2I26X2fe2npykVfHTueMC31ULmrbSF386dg3XfRpTuUy5XPJDnuvLHVhPHwezmX6Vn7
	m6SKGJgVvuoG+Dx4q33C8rLQuf+pMq+WPp0zP2/33HMXfOXu3N8SuDq3/c6tv+Z/+LgTvec/
	W589IY3zzGYde9a8twIOkxO3Hni93EGJpTgj0VCLuag4EQBBAD7HhgIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support to take care of opmode(if any) which can be set by
set_suspend_[disable/mode] callbacks.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 2a67d08..20dae7b 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -67,8 +67,18 @@ enum max77686_ramp_rate {
 
 struct max77686_data {
 	struct regulator_dev *rdev[MAX77686_REGULATORS];
+	unsigned int opmode[MAX77686_REGULATORS];
 };
 
+int max77686_enable(struct regulator_dev *rdev)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  max77686->opmode[rdev->desc->id]);
+}
+
 static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	unsigned int ramp_value = RAMP_RATE_NO_CTRL;
@@ -98,7 +108,7 @@ static struct regulator_ops max77686_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= regulator_is_enabled_regmap,
-	.enable			= regulator_enable_regmap,
+	.enable			= max77686_enable,
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
@@ -109,7 +119,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= regulator_is_enabled_regmap,
-	.enable			= regulator_enable_regmap,
+	.enable			= max77686_enable,
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
@@ -314,12 +324,14 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap;
+	config.driver_data = max77686;
 	platform_set_drvdata(pdev, max77686);
 
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
+		max77686->opmode[i] = regulators[i].enable_mask;
 		max77686->rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(max77686->rdev[i])) {
 			ret = PTR_ERR(max77686->rdev[i]);
-- 
1.7.0.4

