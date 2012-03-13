Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2CMGyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:54:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50458 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2CMGyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:54:06 -0400
Message-ID: <1331621638.3932.1.camel@phoenix>
Subject: [PATCH] regulator: Add MAX8997_VOLTAGE_REGULATOR and
 MAX8997_CURRENT_REGULATOR macros
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 13 Mar 2012 14:53:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997_VOLTAGE_REGULATOR macro has _name and _ops parameters so we can use it
for all regulators with REGULATOR_VOLTAGE type.
The MAX8997_VOLTAGE_REGULATOR now replaces regulator_desc_ldo and
regulator_desc_buck macros.

MAX8997_CURRENT_REGULATOR is for CHARGER and CHARGER_TOPOFF.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |  135 ++++++++++++++----------------------------
 1 files changed, 45 insertions(+), 90 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 35e7332..6e7beee 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -855,103 +855,58 @@ static struct regulator_ops max8997_charger_fixedstate_ops = {
 	.set_current_limit	= max8997_set_voltage_ldobuck_wrap,
 };
 
-#define regulator_desc_ldo(num)		{	\
-	.name		= "LDO"#num,		\
-	.id		= MAX8997_LDO##num,	\
-	.ops		= &max8997_ldo_ops,	\
+#define MAX8997_VOLTAGE_REGULATOR(_name, _ops) {\
+	.name		= #_name,		\
+	.id		= MAX8997_##_name,	\
+	.ops		= &_ops,		\
 	.type		= REGULATOR_VOLTAGE,	\
 	.owner		= THIS_MODULE,		\
 }
-#define regulator_desc_buck(num)		{	\
-	.name		= "BUCK"#num,		\
-	.id		= MAX8997_BUCK##num,	\
-	.ops		= &max8997_buck_ops,	\
-	.type		= REGULATOR_VOLTAGE,	\
+
+#define MAX8997_CURRENT_REGULATOR(_name, _ops) {\
+	.name		= #_name,		\
+	.id		= MAX8997_##_name,	\
+	.ops		= &_ops,		\
+	.type		= REGULATOR_CURRENT,	\
 	.owner		= THIS_MODULE,		\
 }
 
 static struct regulator_desc regulators[] = {
-	regulator_desc_ldo(1),
-	regulator_desc_ldo(2),
-	regulator_desc_ldo(3),
-	regulator_desc_ldo(4),
-	regulator_desc_ldo(5),
-	regulator_desc_ldo(6),
-	regulator_desc_ldo(7),
-	regulator_desc_ldo(8),
-	regulator_desc_ldo(9),
-	regulator_desc_ldo(10),
-	regulator_desc_ldo(11),
-	regulator_desc_ldo(12),
-	regulator_desc_ldo(13),
-	regulator_desc_ldo(14),
-	regulator_desc_ldo(15),
-	regulator_desc_ldo(16),
-	regulator_desc_ldo(17),
-	regulator_desc_ldo(18),
-	regulator_desc_ldo(21),
-	regulator_desc_buck(1),
-	regulator_desc_buck(2),
-	regulator_desc_buck(3),
-	regulator_desc_buck(4),
-	regulator_desc_buck(5),
-	{
-		.name	= "BUCK6",
-		.id	= MAX8997_BUCK6,
-		.ops	= &max8997_fixedvolt_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	= THIS_MODULE,
-	},
-	regulator_desc_buck(7),
-	{
-		.name	= "EN32KHz_AP",
-		.id	= MAX8997_EN32KHZ_AP,
-		.ops	= &max8997_fixedvolt_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	= THIS_MODULE,
-	}, {
-		.name	= "EN32KHz_CP",
-		.id	= MAX8997_EN32KHZ_CP,
-		.ops	= &max8997_fixedvolt_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	= THIS_MODULE,
-	}, {
-		.name	= "ENVICHG",
-		.id	= MAX8997_ENVICHG,
-		.ops	= &max8997_fixedvolt_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	= THIS_MODULE,
-	}, {
-		.name	= "ESAFEOUT1",
-		.id	= MAX8997_ESAFEOUT1,
-		.ops	= &max8997_safeout_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	 = THIS_MODULE,
-	}, {
-		.name	= "ESAFEOUT2",
-		.id	= MAX8997_ESAFEOUT2,
-		.ops	= &max8997_safeout_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	 = THIS_MODULE,
-	}, {
-		.name	= "CHARGER_CV",
-		.id	= MAX8997_CHARGER_CV,
-		.ops	= &max8997_fixedstate_ops,
-		.type	= REGULATOR_VOLTAGE,
-		.owner	 = THIS_MODULE,
-	}, {
-		.name	= "CHARGER",
-		.id	= MAX8997_CHARGER,
-		.ops	= &max8997_charger_ops,
-		.type	= REGULATOR_CURRENT,
-		.owner	 = THIS_MODULE,
-	}, {
-		.name	= "CHARGER_TOPOFF",
-		.id	= MAX8997_CHARGER_TOPOFF,
-		.ops	= &max8997_charger_fixedstate_ops,
-		.type	= REGULATOR_CURRENT,
-		.owner	 = THIS_MODULE,
-	},
+	MAX8997_VOLTAGE_REGULATOR(LDO1, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO2, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO3, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO4, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO5, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO6, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO7, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO8, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO9, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO10, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO11, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO12, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO13, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO14, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO15, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO16, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO17, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO18, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(LDO21, max8997_ldo_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK1, max8997_buck_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK2, max8997_buck_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK3, max8997_buck_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK4, max8997_buck_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK5, max8997_buck_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK6, max8997_fixedvolt_ops),
+	MAX8997_VOLTAGE_REGULATOR(BUCK7, max8997_buck_ops),
+	MAX8997_VOLTAGE_REGULATOR(EN32KHZ_AP, max8997_fixedvolt_ops),
+	MAX8997_VOLTAGE_REGULATOR(EN32KHZ_CP, max8997_fixedvolt_ops),
+	MAX8997_VOLTAGE_REGULATOR(ENVICHG, max8997_fixedvolt_ops),
+	MAX8997_VOLTAGE_REGULATOR(ESAFEOUT1, max8997_safeout_ops),
+	MAX8997_VOLTAGE_REGULATOR(ESAFEOUT2, max8997_safeout_ops),
+	MAX8997_VOLTAGE_REGULATOR(CHARGER_CV, max8997_fixedstate_ops),
+	MAX8997_CURRENT_REGULATOR(CHARGER, max8997_charger_ops),
+	MAX8997_CURRENT_REGULATOR(CHARGER_TOPOFF,
+				  max8997_charger_fixedstate_ops),
 };
 
 static __devinit int max8997_pmic_probe(struct platform_device *pdev)
-- 
1.7.5.4



