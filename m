Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1FTMF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:05:26 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16485 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1FTMFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:05:23 -0400
X-SpamScore: 18
X-BigFish: VPS18(zz82c2szz1202h10d2nzz8275bhz32i2a8h668h839h)
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
Subject: [PATCHv3 5/11 ] Regulator: Fixed DA9052 _sel() functions
From: ashishj3 <ashish.jangam@kpitcummins.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <lrg@slimlogic.co.uk>, <linux-kernel@vger.kernel.org>,
        <dajun.chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 17:33:12 +0530
Message-ID: <1308571392.3180.37.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v2:
- fixed da9052_get_regulator_voltage_sel()
- fixed da9052_get_buckperi_voltage_sel()
- couple of code formatting and word wrapping issues.
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index a15f2ec..f609a5c 100755
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -24,7 +24,7 @@
 #include <linux/mfd/da9052/reg.h>
 #include <linux/mfd/da9052/pdata.h>
 
-/* Buck step size Macros */
+/* Buck step size */
 #define DA9052_BUCK_PERI_3uV_STEP		100000
 #define DA9052_BUCK_PERI_REG_MAP_UPTO_3uV	24
 #define DA9052_CONST_3uV			3000000
@@ -47,7 +47,6 @@ struct da9052_regulator_info {
 	unsigned char volt_shift;
 	unsigned char en_bit;
 	unsigned char activate_bit;
-
 };
 
 struct da9052_regulator {
@@ -57,7 +56,7 @@ struct da9052_regulator {
 };
 
 static int verify_range(struct da9052_regulator_info *info,
-							int min_uV, int max_uV)
+			int min_uV, int max_uV)
 {
 	if (min_uV < info->min_uV || min_uV > info->max_uV)
 		return -EINVAL;
@@ -74,9 +73,8 @@ static int da9052_regulator_enable(struct regulator_dev *rdev)
 	int offset = rdev_get_id(rdev);
 
 	return da9052_reg_update(regulator->da9052,
-					DA9052_BUCKCORE_REG + offset,
-					1 << info->en_bit, 1);
-
+				 DA9052_BUCKCORE_REG + offset,
+				 1 << info->en_bit, 1);
 }
 
 static int da9052_regulator_disable(struct regulator_dev *rdev)
@@ -86,9 +84,8 @@ static int da9052_regulator_disable(struct regulator_dev *rdev)
 	int offset = rdev_get_id(rdev);
 
 	return da9052_reg_update(regulator->da9052,
-					DA9052_BUCKCORE_REG + offset,
-					1 << info->en_bit, 0);
-
+				 DA9052_BUCKCORE_REG + offset,
+				 1 << info->en_bit, 0);
 }
 
 static int da9052_regulator_is_enabled(struct regulator_dev *rdev)
@@ -103,7 +100,6 @@ static int da9052_regulator_is_enabled(struct regulator_dev *rdev)
 		return ret;
 
 	return ret & (1 << info->en_bit);
-
 }
 
 static int da9052_dcdc_get_current_limit(struct regulator_dev *rdev)
@@ -116,9 +112,8 @@ static int da9052_dcdc_get_current_limit(struct regulator_dev *rdev)
 	if (ret < 0)
 		return ret;
 
-/*
- * Determine the odd or event bit pos of the buck current limit field
-*/
+	/* Determine the even or odd position of the buck current limit
+	 * register field */
 	if (offset % 2 == 0)
 		ret = (ret & DA9052_BUCK_ILIM_MASK_EVEN) >> 2;
 	else
@@ -128,7 +123,7 @@ static int da9052_dcdc_get_current_limit(struct regulator_dev *rdev)
 }
 
 static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
-					int max_uA)
+					 int max_uA)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	int offset = rdev_get_id(rdev);
@@ -146,24 +141,22 @@ static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
 	else if (min_uA <= 1200)
 		reg_val = DA9052_BUCK_CURRENT_LIMIT_1200mA;
 
-/*
- * Determine the odd or event bit pos of the buck current limit field
-*/
+	/* Determine the even or odd position of the buck current limit
+	 * register field */
 	if (offset % 2 == 0)
 		return da9052_reg_update(regulator->da9052,
-					DA9052_BUCKA_REG + offset/2,
-					DA9052_BUCK_ILIM_MASK_EVEN,
-					reg_val << 2);
+					 DA9052_BUCKA_REG + offset/2,
+					 DA9052_BUCK_ILIM_MASK_EVEN,
+					 reg_val << 2);
 	else
 		return da9052_reg_update(regulator->da9052,
-					DA9052_BUCKA_REG + offset/2,
-					DA9052_BUCK_ILIM_MASK_ODD,
-					reg_val << 6);
-
+					 DA9052_BUCKA_REG + offset/2,
+					 DA9052_BUCK_ILIM_MASK_ODD,
+					 reg_val << 6);
 }
 
 static int da9052_list_buckperi_voltage(struct regulator_dev *rdev,
-							unsigned int selector)
+					unsigned int selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -171,9 +164,9 @@ static int da9052_list_buckperi_voltage(struct regulator_dev *rdev,
 
 	if (selector >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV) {
 		volt_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV * info->step_uV) +
-						info->min_uV);
+			    info->min_uV);
 		volt_uV += (selector - DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
-						*(DA9052_BUCK_PERI_3uV_STEP);
+			    * (DA9052_BUCK_PERI_3uV_STEP);
 	} else
 		volt_uV = (selector * info->step_uV) + info->min_uV;
 
@@ -184,7 +177,7 @@ static int da9052_list_buckperi_voltage(struct regulator_dev *rdev,
 }
 
 static int da9052_list_voltage(struct regulator_dev *rdev,
-						unsigned int selector)
+			       unsigned int selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -199,7 +192,8 @@ static int da9052_list_voltage(struct regulator_dev *rdev,
 }
 
 static int da9052_regulator_set_voltage_int(struct regulator_dev *rdev,
-			int min_uV, int max_uV, unsigned int *selector)
+					    int min_uV, int max_uV,
+					    unsigned int *selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -217,20 +211,20 @@ static int da9052_regulator_set_voltage_int(struct regulator_dev *rdev,
 		return ret;
 
 	return da9052_reg_update(regulator->da9052,
-					DA9052_BUCKCORE_REG + offset,
-					(1 << info->volt_shift) - 1, *selector);
-
+				 DA9052_BUCKCORE_REG + offset,
+				 (1 << info->volt_shift) - 1, *selector);
 }
 
 static int da9052_set_ldo_voltage(struct regulator_dev *rdev,
-			int min_uV, int max_uV, unsigned int *selector)
+				  int min_uV, int max_uV,
+				  unsigned int *selector)
 {
 	return da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
-
 }
 
 static int da9052_set_ldo5_6_voltage(struct regulator_dev *rdev,
-			int min_uV, int max_uV, unsigned int *selector)
+				     int min_uV, int max_uV,
+				     unsigned int *selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -240,17 +234,16 @@ static int da9052_set_ldo5_6_voltage(struct regulator_dev *rdev,
 	if (ret < 0)
 		return ret;
 
-/*
- * Some LD0s are DVC control which requires to activate the regulator bit to
- * implment the changes on the LDO output.
-*/
+	/* Some LD0s are DVC controlled which requires enabling of
+	 * the LDO activate bit to implment the changes on the
+	 * LDO output. */
 	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG, 0,
-				info->activate_bit);
-
+				 info->activate_bit);
 }
 
 static int da9052_set_dcdc_voltage(struct regulator_dev *rdev,
-			int min_uV, int max_uV, unsigned int *selector)
+				   int min_uV, int max_uV,
+				   unsigned int *selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -260,13 +253,11 @@ static int da9052_set_dcdc_voltage(struct regulator_dev *rdev,
 	if (ret < 0)
 		return ret;
 
-/*
- * Some DCDCs are DVC control which requires to activate the regulator bit to
- * implment the changes on the DCDC output.
-*/
+	/* Some DCDCs are DVC controlled which requires enabling of
+	 * the DCDC activate bit to implment the changes on the
+	 * DCDC output. */
 	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG, 0,
-				info->activate_bit);
-
+				 info->activate_bit);
 }
 
 static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
@@ -282,12 +273,11 @@ static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
 
 	ret &= ((1 << info->volt_shift) - 1);
 
-	return da9052_list_voltage(rdev, ret);
-
+	return ret;
 }
 
 static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
-					int max_uV, unsigned int *selector)
+				       int max_uV, unsigned int *selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -300,7 +290,7 @@ static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
 
 	if (min_uV >= DA9052_CONST_3uV)
 		*selector = DA9052_CONST_3uV + ((min_uV - DA9052_CONST_3uV) /
-					(DA9052_BUCK_PERI_3uV_STEP));
+			    (DA9052_BUCK_PERI_3uV_STEP));
 	else
 		*selector = (min_uV - info->min_uV) / info->step_uV;
 
@@ -309,9 +299,8 @@ static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
 		return ret;
 
 	return da9052_reg_update(regulator->da9052,
-					DA9052_BUCKCORE_REG + offset,
-					(1 << info->volt_shift) - 1, *selector);
-
+				 DA9052_BUCKCORE_REG + offset,
+				 (1 << info->volt_shift) - 1, *selector);
 }
 
 static int da9052_get_buckperi_voltage_sel(struct regulator_dev *rdev)
@@ -322,122 +311,125 @@ static int da9052_get_buckperi_voltage_sel(struct regulator_dev *rdev)
 	int ret;
 
 	ret = da9052_reg_read(regulator->da9052, DA9052_BUCKCORE_REG + offset);
-
 	if (ret < 0)
 		return ret;
 
 	ret &= ((1 << info->volt_shift) - 1);
 
-	return da9052_list_buckperi_voltage(rdev, ret);
-
+	return ret;
 }
 
 static struct regulator_ops da9052_buckperi_ops = {
-	.is_enabled	 = da9052_regulator_is_enabled,
-	.enable		 = da9052_regulator_enable,
-	.disable	 = da9052_regulator_disable,
+	.list_voltage = da9052_list_buckperi_voltage,
+	.get_voltage_sel = da9052_get_buckperi_voltage_sel,
+	.set_voltage = da9052_set_buckperi_voltage,
+
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
-	.get_voltage_sel = da9052_get_buckperi_voltage_sel,
-	.set_voltage	= da9052_set_buckperi_voltage,
-	.list_voltage	= da9052_list_buckperi_voltage,
+
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
 };
 
 static struct regulator_ops da9052_dcdc_ops = {
-	.is_enabled	 = da9052_regulator_is_enabled,
-	.enable		 = da9052_regulator_enable,
-	.disable	 = da9052_regulator_disable,
+	.set_voltage = da9052_set_dcdc_voltage,
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
+
+	.list_voltage = da9052_list_voltage,
 	.get_voltage_sel = da9052_get_regulator_voltage_sel,
-	.set_voltage	= da9052_set_dcdc_voltage,
-	.list_voltage	= da9052_list_voltage,
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
 };
 
 static struct regulator_ops da9052_ldo5_6_ops = {
-	.is_enabled	 = da9052_regulator_is_enabled,
-	.enable		 = da9052_regulator_enable,
-	.disable	 = da9052_regulator_disable,
+	.set_voltage = da9052_set_ldo5_6_voltage,
+
+	.list_voltage = da9052_list_voltage,
 	.get_voltage_sel = da9052_get_regulator_voltage_sel,
-	.set_voltage	= da9052_set_ldo5_6_voltage,
-	.list_voltage	= da9052_list_voltage,
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
 };
 
 static struct regulator_ops da9052_ldo_ops = {
-	.is_enabled	 = da9052_regulator_is_enabled,
-	.enable		 = da9052_regulator_enable,
-	.disable	 = da9052_regulator_disable,
+	.set_voltage = da9052_set_ldo_voltage,
+
+	.list_voltage = da9052_list_voltage,
 	.get_voltage_sel = da9052_get_regulator_voltage_sel,
-	.set_voltage	= da9052_set_ldo_voltage,
-	.list_voltage	= da9052_list_voltage,
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
 };
 
 #define DA9052_LDO5_6(_id, step, min, max, sbits, ebits, abits) \
 {\
-		.reg_desc	= {\
-		.name		= "LDO" #_id,\
-		.ops		= &da9052_ldo5_6_ops,\
-		.type		= REGULATOR_VOLTAGE,\
-		.id		= _id,\
-		.owner		= THIS_MODULE,\
+	.reg_desc = {\
+		.name = "LDO" #_id,\
+		.ops = &da9052_ldo5_6_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
 	},\
-		.min_uV		= (min) * 1000,\
-		.max_uV		= (max) * 1000,\
-		.step_uV	= (step) * 1000,\
-		.volt_shift	= (sbits),\
-		.en_bit		= (ebits),\
-		.activate_bit	= (abits),\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
 }
 
 #define DA9052_LDO(_id, step, min, max, sbits, ebits, abits) \
 {\
-		.reg_desc	= {\
-		.name		= "LDO" #_id,\
-		.ops		= &da9052_ldo_ops,\
-		.type		= REGULATOR_VOLTAGE,\
-		.id		= _id,\
-		.owner		= THIS_MODULE,\
+	.reg_desc = {\
+		.name = "LDO" #_id,\
+		.ops = &da9052_ldo_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
 	},\
-		.min_uV		= (min) * 1000,\
-		.max_uV		= (max) * 1000,\
-		.step_uV	= (step) * 1000,\
-		.volt_shift	= (sbits),\
-		.en_bit		= (ebits),\
-		.activate_bit	= (abits),\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
 }
 
 #define DA9052_DCDC(_id, step, min, max, sbits, ebits, abits) \
 {\
-		.reg_desc	= {\
-		.name		= "BUCK" #_id,\
-		.ops		= &da9052_dcdc_ops,\
-		.type		= REGULATOR_VOLTAGE,\
-		.id		= _id,\
-		.owner		= THIS_MODULE,\
+	.reg_desc = {\
+		.name = "BUCK" #_id,\
+		.ops = &da9052_dcdc_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
 	},\
-		.min_uV		= (min) * 1000,\
-		.max_uV		= (max) * 1000,\
-		.step_uV	= (step) * 1000,\
-		.volt_shift	= (sbits),\
-		.en_bit		= (ebits),\
-		.activate_bit	= (abits),\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
 }
 
 #define DA9052_BUCKPERI(_id, step, min, max, sbits, ebits, abits) \
 {\
-		.reg_desc	= {\
-		.name		= "BUCK" #_id,\
-		.ops		= &da9052_buckperi_ops,\
-		.type		= REGULATOR_VOLTAGE,\
-		.id		= _id,\
-		.owner		= THIS_MODULE,\
+	.reg_desc = {\
+		.name = "BUCK" #_id,\
+		.ops = &da9052_buckperi_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
 	},\
-		.min_uV		= (min) * 1000,\
-		.max_uV		= (max) * 1000,\
-		.step_uV	= (step) * 1000,\
-		.volt_shift	= (sbits),\
-		.en_bit		= (ebits),\
-		.activate_bit	= (abits),\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
 }
 
 struct da9052_regulator_info da9052_regulator_info[] = {
@@ -459,7 +451,6 @@ struct da9052_regulator_info da9052_regulator_info[] = {
 	DA9052_LDO(13, 50, 1200, 3600, 6, 6, 0),
 };
 
-
 static inline struct da9052_regulator_info *find_regulator_info(int id)
 {
 	struct da9052_regulator_info *info;
@@ -470,6 +461,7 @@ static inline struct da9052_regulator_info *find_regulator_info(int id)
 		if (info->reg_desc.id == id)
 			return info;
 	}
+
 	return NULL;
 }
 
@@ -495,12 +487,12 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	}
 
 	regulator->rdev = regulator_register(&regulator->info->reg_desc,
-						&pdev->dev,
-						pdata->regulators[pdev->id],
-						regulator);
+					     &pdev->dev,
+					     pdata->regulators[pdev->id],
+					     regulator);
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
-				regulator->info->reg_desc.name);
+			regulator->info->reg_desc.name);
 		ret = PTR_ERR(regulator->rdev);
 		goto err;
 	}
@@ -511,7 +503,6 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 err:
 	kfree(regulator);
 	return ret;
-
 }
 
 static int __devexit da9052_regulator_remove(struct platform_device *pdev)
@@ -519,18 +510,19 @@ static int __devexit da9052_regulator_remove(struct platform_device *pdev)
 	struct da9052_regulator *regulator = platform_get_drvdata(pdev);
 
 	regulator_unregister(regulator->rdev);
-
 	kfree(regulator);
+
 	return 0;
 }
 
 static struct platform_driver da9052_regulator_driver = {
+	.probe = da9052_regulator_probe,
+	.remove = __devexit_p(da9052_regulator_remove),
 	.driver = {
-		.name	= "da9052-regulator",
-		.owner	= THIS_MODULE,
+		.name = "da9052-regulator",
+		.owner = THIS_MODULE,
 	},
-	.probe		= da9052_regulator_probe,
-	.remove		= __devexit_p(da9052_regulator_remove),
+
 };
 
 static int __init da9052_regulator_init(void)


