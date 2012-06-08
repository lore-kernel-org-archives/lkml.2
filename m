Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab2FHHl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:41:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50054 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2FHHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:41:55 -0400
Message-ID: <1339141308.16616.4.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: mc13xxx: Convert to
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 15:41:48 +0800
In-Reply-To: <1339141174.16616.2.camel@phoenix>
References: <1339141174.16616.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13783-regulator.c      |   38 ++++++++++++-------------
 drivers/regulator/mc13892-regulator.c      |   42 ++++++++++++++--------------
 drivers/regulator/mc13xxx-regulator-core.c |   30 ++++----------------
 drivers/regulator/mc13xxx.h                |    9 ++----
 4 files changed, 49 insertions(+), 70 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 7dcdfa2..4932e34 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -93,78 +93,78 @@
 
 
 /* Voltage Values */
-static const int mc13783_sw3_val[] = {
+static const unsigned int mc13783_sw3_val[] = {
 	5000000, 5000000, 5000000, 5500000,
 };
 
-static const int mc13783_vaudio_val[] = {
+static const unsigned int mc13783_vaudio_val[] = {
 	2775000,
 };
 
-static const int mc13783_viohi_val[] = {
+static const unsigned int mc13783_viohi_val[] = {
 	2775000,
 };
 
-static const int mc13783_violo_val[] = {
+static const unsigned int mc13783_violo_val[] = {
 	1200000, 1300000, 1500000, 1800000,
 };
 
-static const int mc13783_vdig_val[] = {
+static const unsigned int mc13783_vdig_val[] = {
 	1200000, 1300000, 1500000, 1800000,
 };
 
-static const int mc13783_vgen_val[] = {
+static const unsigned int mc13783_vgen_val[] = {
 	1200000, 1300000, 1500000, 1800000,
 	1100000, 2000000, 2775000, 2400000,
 };
 
-static const int mc13783_vrfdig_val[] = {
+static const unsigned int mc13783_vrfdig_val[] = {
 	1200000, 1500000, 1800000, 1875000,
 };
 
-static const int mc13783_vrfref_val[] = {
+static const unsigned int mc13783_vrfref_val[] = {
 	2475000, 2600000, 2700000, 2775000,
 };
 
-static const int mc13783_vrfcp_val[] = {
+static const unsigned int mc13783_vrfcp_val[] = {
 	2700000, 2775000,
 };
 
-static const int mc13783_vsim_val[] = {
+static const unsigned int mc13783_vsim_val[] = {
 	1800000, 2900000, 3000000,
 };
 
-static const int mc13783_vesim_val[] = {
+static const unsigned int mc13783_vesim_val[] = {
 	1800000, 2900000,
 };
 
-static const int mc13783_vcam_val[] = {
+static const unsigned int mc13783_vcam_val[] = {
 	1500000, 1800000, 2500000, 2550000,
 	2600000, 2750000, 2800000, 3000000,
 };
 
-static const int mc13783_vrfbg_val[] = {
+static const unsigned int mc13783_vrfbg_val[] = {
 	1250000,
 };
 
-static const int mc13783_vvib_val[] = {
+static const unsigned int mc13783_vvib_val[] = {
 	1300000, 1800000, 2000000, 3000000,
 };
 
-static const int mc13783_vmmc_val[] = {
+static const unsigned int mc13783_vmmc_val[] = {
 	1600000, 1800000, 2000000, 2600000,
 	2700000, 2800000, 2900000, 3000000,
 };
 
-static const int mc13783_vrf_val[] = {
+static const unsigned int mc13783_vrf_val[] = {
 	1500000, 1875000, 2700000, 2775000,
 };
 
-static const int mc13783_gpo_val[] = {
+static const unsigned int mc13783_gpo_val[] = {
 	3100000,
 };
 
-static const int mc13783_pwgtdrv_val[] = {
+static const unsigned int mc13783_pwgtdrv_val[] = {
 	5500000,
 };
 
@@ -328,7 +328,7 @@ static struct regulator_ops mc13783_gpo_regulator_ops = {
 	.enable = mc13783_gpo_regulator_enable,
 	.disable = mc13783_gpo_regulator_disable,
 	.is_enabled = mc13783_gpo_regulator_is_enabled,
-	.list_voltage = mc13xxx_regulator_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
 	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 970a233..6329723 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -150,12 +150,12 @@
 #define MC13892_USB1				50
 #define MC13892_USB1_VUSBEN			(1<<3)
 
-static const int mc13892_vcoincell[] = {
+static const unsigned int mc13892_vcoincell[] = {
 	2500000, 2700000, 2800000, 2900000, 3000000, 3100000,
 	3200000, 3300000,
 };
 
-static const int mc13892_sw1[] = {
+static const unsigned int mc13892_sw1[] = {
 	600000,   625000,  650000,  675000,  700000,  725000,
 	750000,   775000,  800000,  825000,  850000,  875000,
 	900000,   925000,  950000,  975000, 1000000, 1025000,
@@ -164,7 +164,7 @@ static const int mc13892_sw1[] = {
 	1350000, 1375000
 };
 
-static const int mc13892_sw[] = {
+static const unsigned int mc13892_sw[] = {
 	600000,   625000,  650000,  675000,  700000,  725000,
 	750000,   775000,  800000,  825000,  850000,  875000,
 	900000,   925000,  950000,  975000, 1000000, 1025000,
@@ -176,65 +176,65 @@ static const int mc13892_sw[] = {
 	1800000, 1825000, 1850000, 1875000
 };
 
-static const int mc13892_swbst[] = {
+static const unsigned int mc13892_swbst[] = {
 	5000000,
 };
 
-static const int mc13892_viohi[] = {
+static const unsigned int mc13892_viohi[] = {
 	2775000,
 };
 
-static const int mc13892_vpll[] = {
+static const unsigned int mc13892_vpll[] = {
 	1050000, 1250000, 1650000, 1800000,
 };
 
-static const int mc13892_vdig[] = {
+static const unsigned int mc13892_vdig[] = {
 	1050000, 1250000, 1650000, 1800000,
 };
 
-static const int mc13892_vsd[] = {
+static const unsigned int mc13892_vsd[] = {
 	1800000, 2000000, 2600000, 2700000,
 	2800000, 2900000, 3000000, 3150000,
 };
 
-static const int mc13892_vusb2[] = {
+static const unsigned int mc13892_vusb2[] = {
 	2400000, 2600000, 2700000, 2775000,
 };
 
-static const int mc13892_vvideo[] = {
+static const unsigned int mc13892_vvideo[] = {
 	2700000, 2775000, 2500000, 2600000,
 };
 
-static const int mc13892_vaudio[] = {
+static const unsigned int mc13892_vaudio[] = {
 	2300000, 2500000, 2775000, 3000000,
 };
 
-static const int mc13892_vcam[] = {
+static const unsigned int mc13892_vcam[] = {
 	2500000, 2600000, 2750000, 3000000,
 };
 
-static const int mc13892_vgen1[] = {
+static const unsigned int mc13892_vgen1[] = {
 	1200000, 1500000, 2775000, 3150000,
 };
 
-static const int mc13892_vgen2[] = {
+static const unsigned int mc13892_vgen2[] = {
 	1200000, 1500000, 1600000, 1800000,
 	2700000, 2800000, 3000000, 3150000,
 };
 
-static const int mc13892_vgen3[] = {
+static const unsigned int mc13892_vgen3[] = {
 	1800000, 2900000,
 };
 
-static const int mc13892_vusb[] = {
+static const unsigned int mc13892_vusb[] = {
 	3300000,
 };
 
-static const int mc13892_gpo[] = {
+static const unsigned int mc13892_gpo[] = {
 	2750000,
 };
 
-static const int mc13892_pwgtdrv[] = {
+static const unsigned int mc13892_pwgtdrv[] = {
 	5000000,
 };
 
@@ -394,7 +394,7 @@ static struct regulator_ops mc13892_gpo_regulator_ops = {
 	.enable = mc13892_gpo_regulator_enable,
 	.disable = mc13892_gpo_regulator_disable,
 	.is_enabled = mc13892_gpo_regulator_is_enabled,
-	.list_voltage = mc13xxx_regulator_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
 	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
@@ -436,7 +436,7 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	u32 valread;
 	int ret;
 
-	value = mc13892_regulators[id].voltages[selector];
+	value = rdev->desc->volt_table[selector];
 
 	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx,
@@ -470,7 +470,7 @@ err:
 
 static struct regulator_ops mc13892_sw_regulator_ops = {
 	.is_enabled = mc13xxx_sw_regulator_is_enabled,
-	.list_voltage = mc13xxx_regulator_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = mc13892_sw_regulator_set_voltage_sel,
 	.get_voltage = mc13892_sw_regulator_get_voltage,
 };
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 3e19171..8a6b050 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -80,20 +80,6 @@ static int mc13xxx_regulator_is_enabled(struct regulator_dev *rdev)
 	return (val & mc13xxx_regulators[id].enable_bit) != 0;
 }
 
-int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
-						unsigned selector)
-{
-	int id = rdev_get_id(rdev);
-	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
-
-	if (selector >= mc13xxx_regulators[id].desc.n_voltages)
-		return -EINVAL;
-
-	return mc13xxx_regulators[id].voltages[selector];
-}
-EXPORT_SYMBOL_GPL(mc13xxx_regulator_list_voltage);
-
 static int mc13xxx_regulator_set_voltage_sel(struct regulator_dev *rdev,
 					     unsigned selector)
 {
@@ -135,14 +121,14 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
 
 	BUG_ON(val >= mc13xxx_regulators[id].desc.n_voltages);
 
-	return mc13xxx_regulators[id].voltages[val];
+	return rdev->desc->volt_table[val];
 }
 
 struct regulator_ops mc13xxx_regulator_ops = {
 	.enable = mc13xxx_regulator_enable,
 	.disable = mc13xxx_regulator_disable,
 	.is_enabled = mc13xxx_regulator_is_enabled,
-	.list_voltage = mc13xxx_regulator_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = mc13xxx_regulator_set_voltage_sel,
 	.get_voltage = mc13xxx_regulator_get_voltage,
 };
@@ -151,15 +137,13 @@ EXPORT_SYMBOL_GPL(mc13xxx_regulator_ops);
 int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 	       int max_uV, unsigned *selector)
 {
-	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
 		__func__, id, min_uV, max_uV);
 
-	if (min_uV <= mc13xxx_regulators[id].voltages[0] &&
-	    mc13xxx_regulators[id].voltages[0] <= max_uV)
+	if (min_uV <= rdev->desc->volt_table[0] &&
+	    rdev->desc->volt_table[0] <= max_uV)
 		return 0;
 	else
 		return -EINVAL;
@@ -168,13 +152,11 @@ EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_set_voltage);
 
 int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev)
 {
-	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	return mc13xxx_regulators[id].voltages[0];
+	return rdev->desc->volt_table[0];
 }
 EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_get_voltage);
 
@@ -182,7 +164,7 @@ struct regulator_ops mc13xxx_fixed_regulator_ops = {
 	.enable = mc13xxx_regulator_enable,
 	.disable = mc13xxx_regulator_disable,
 	.is_enabled = mc13xxx_regulator_is_enabled,
-	.list_voltage = mc13xxx_regulator_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
 	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index 044aba4..9a8f72c 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -22,7 +22,6 @@ struct mc13xxx_regulator {
 	int vsel_shift;
 	int vsel_mask;
 	int hi_bit;
-	int const *voltages;
 };
 
 struct mc13xxx_regulator_priv {
@@ -35,8 +34,6 @@ struct mc13xxx_regulator_priv {
 
 extern int mc13xxx_sw_regulator(struct regulator_dev *rdev);
 extern int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev);
-extern int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
-						unsigned selector);
 extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector);
 extern int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev);
@@ -68,6 +65,7 @@ extern struct regulator_ops mc13xxx_fixed_regulator_ops;
 		.desc = {						\
 			.name = #_name,					\
 			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.volt_table =  _voltages,			\
 			.ops = &_ops,			\
 			.type = REGULATOR_VOLTAGE,			\
 			.id = prefix ## _name,		\
@@ -78,7 +76,6 @@ extern struct regulator_ops mc13xxx_fixed_regulator_ops;
 		.vsel_reg = prefix ## _vsel_reg,			\
 		.vsel_shift = prefix ## _vsel_reg ## _ ## _name ## VSEL,\
 		.vsel_mask = prefix ## _vsel_reg ## _ ## _name ## VSEL_M,\
-		.voltages =  _voltages,					\
 	}
 
 #define MC13xxx_FIXED_DEFINE(prefix, _name, _reg, _voltages, _ops)	\
@@ -86,6 +83,7 @@ extern struct regulator_ops mc13xxx_fixed_regulator_ops;
 		.desc = {						\
 			.name = #_name,					\
 			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.volt_table =  _voltages,			\
 			.ops = &_ops,		\
 			.type = REGULATOR_VOLTAGE,			\
 			.id = prefix ## _name,		\
@@ -93,7 +91,6 @@ extern struct regulator_ops mc13xxx_fixed_regulator_ops;
 		},							\
 		.reg = prefix ## _reg,				\
 		.enable_bit = prefix ## _reg ## _ ## _name ## EN,	\
-		.voltages =  _voltages,					\
 	}
 
 #define MC13xxx_GPO_DEFINE(prefix, _name, _reg,  _voltages, _ops)	\
@@ -101,6 +98,7 @@ extern struct regulator_ops mc13xxx_fixed_regulator_ops;
 		.desc = {						\
 			.name = #_name,					\
 			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.volt_table =  _voltages,			\
 			.ops = &_ops,		\
 			.type = REGULATOR_VOLTAGE,			\
 			.id = prefix ## _name,		\
@@ -108,7 +106,6 @@ extern struct regulator_ops mc13xxx_fixed_regulator_ops;
 		},							\
 		.reg = prefix ## _reg,				\
 		.enable_bit = prefix ## _reg ## _ ## _name ## EN,	\
-		.voltages =  _voltages,					\
 	}
 
 #define MC13xxx_DEFINE_SW(_name, _reg, _vsel_reg, _voltages, ops)	\
-- 
1.7.9.5



