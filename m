Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2L1JK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:10:29 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58129 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2L1JK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:10:27 -0500
Message-ID: <1356685820.27172.4.camel@phoenix>
Subject: [PATCH 2/3] regulator: max8998: Use uV in voltage_map_desc
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2012 17:10:20 +0800
In-Reply-To: <1356685743.27172.2.camel@phoenix>
References: <1356685743.27172.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division may truncate.
This happens when pdata->buckx_voltagex setting is not align with 1000 uV.
Thus use uV in voltage_map_desc, this ensures the selected voltage won't less
than pdata buckx_voltagex settings.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8998.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index b821d08..06be8cc 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -51,39 +51,39 @@ struct voltage_map_desc {
 	int step;
 };
 
-/* Voltage maps */
+/* Voltage maps in uV*/
 static const struct voltage_map_desc ldo23_voltage_map_desc = {
-	.min = 800,	.step = 50,	.max = 1300,
+	.min = 800000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo456711_voltage_map_desc = {
-	.min = 1600,	.step = 100,	.max = 3600,
+	.min = 1600000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc ldo8_voltage_map_desc = {
-	.min = 3000,	.step = 100,	.max = 3600,
+	.min = 3000000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc ldo9_voltage_map_desc = {
-	.min = 2800,	.step = 100,	.max = 3100,
+	.min = 2800000,	.step = 100000,	.max = 3100000,
 };
 static const struct voltage_map_desc ldo10_voltage_map_desc = {
-	.min = 950,	.step = 50,	.max = 1300,
+	.min = 95000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo1213_voltage_map_desc = {
-	.min = 800,	.step = 100,	.max = 3300,
+	.min = 800000,	.step = 100000,	.max = 3300000,
 };
 static const struct voltage_map_desc ldo1415_voltage_map_desc = {
-	.min = 1200,	.step = 100,	.max = 3300,
+	.min = 1200000,	.step = 100000,	.max = 3300000,
 };
 static const struct voltage_map_desc ldo1617_voltage_map_desc = {
-	.min = 1600,	.step = 100,	.max = 3600,
+	.min = 1600000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc buck12_voltage_map_desc = {
-	.min = 750,	.step = 25,	.max = 1525,
+	.min = 750000,	.step = 25000,	.max = 1525000,
 };
 static const struct voltage_map_desc buck3_voltage_map_desc = {
-	.min = 1600,	.step = 100,	.max = 3600,
+	.min = 1600000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc buck4_voltage_map_desc = {
-	.min = 800,	.step = 100,	.max = 2300,
+	.min = 800000,	.step = 100000,	.max = 2300000,
 };
 
 static const struct voltage_map_desc *ldo_voltage_map[] = {
@@ -445,7 +445,7 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 	if (max8998->iodev->type == TYPE_MAX8998 && !(val & MAX8998_ENRAMP))
 		return 0;
 
-	difference = (new_selector - old_selector) * desc->step;
+	difference = (new_selector - old_selector) * desc->step / 1000;
 	if (difference > 0)
 		return difference / ((val & 0x0f) + 1);
 
@@ -702,7 +702,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage1 / 1000))
+		       < pdata->buck1_voltage1)
 			i++;
 		max8998->buck1_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
@@ -713,7 +713,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage2 / 1000))
+		       < pdata->buck1_voltage2)
 			i++;
 
 		max8998->buck1_vol[1] = i;
@@ -725,7 +725,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage3 / 1000))
+		       < pdata->buck1_voltage3)
 			i++;
 
 		max8998->buck1_vol[2] = i;
@@ -737,7 +737,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage4 / 1000))
+		       < pdata->buck1_voltage4)
 			i++;
 
 		max8998->buck1_vol[3] = i;
@@ -763,7 +763,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck2_voltage1 / 1000))
+		       < pdata->buck2_voltage1)
 			i++;
 		max8998->buck2_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
@@ -774,7 +774,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck2_voltage2 / 1000))
+		       < pdata->buck2_voltage2)
 			i++;
 		max8998->buck2_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
@@ -792,8 +792,8 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 			int count = (desc->max - desc->min) / desc->step + 1;
 
 			regulators[index].n_voltages = count;
-			regulators[index].min_uV = desc->min * 1000;
-			regulators[index].uV_step = desc->step * 1000;
+			regulators[index].min_uV = desc->min;
+			regulators[index].uV_step = desc->step;
 		}
 
 		config.dev = max8998->dev;
-- 
1.7.9.5



