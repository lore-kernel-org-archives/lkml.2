Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2EVE0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:26:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35752 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab2EVE0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:26:51 -0400
Message-ID: <1337660802.3814.0.camel@phoenix>
Subject: [PATCH v2] regulator: palmas: Use
 regulator_[list|map]_voltage_linear() for palmas_ops_smps10
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 22 May 2012 12:26:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
---
V2: trivial typo fix

 drivers/regulator/palmas-regulator.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 9b7ca90..4fd8333 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -400,19 +400,14 @@ static struct regulator_ops palmas_ops_smps = {
 	.map_voltage		= palmas_map_voltage_smps,
 };
 
-static int palmas_list_voltage_smps10(struct regulator_dev *dev,
-					unsigned selector)
-{
-	return 3750000 + (selector * 1250000);
-}
-
 static struct regulator_ops palmas_ops_smps10 = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.list_voltage		= palmas_list_voltage_smps10,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 };
 
 static int palmas_is_enabled_ldo(struct regulator_dev *dev)
@@ -675,6 +670,8 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg = PALMAS_SMPS10_STATUS;
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
+			pmic->desc[id].min_uV = 3750000;
+			pmic->desc[id].uV_step = 1250000;
 		}
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
-- 
1.7.5.4



