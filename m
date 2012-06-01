Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2FAER1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 00:17:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58907 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2FAER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 00:17:26 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-ca-4fc8425402c0
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] regulator: MAX77686: Add Maxim 77686 regulator driver
Date: Fri, 01 Jun 2012 13:17:14 +0900
Message-id: <1338524234-12165-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jQd0QpxP+Bi8vKFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MlSvWMxZMyah4sFK2gXFxWBcjJ4eEgIlE69Hp7BC2mMSFe+vZ
	uhi5OIQEpjNKnFtyjRXCWckk8bf/CwtIFZuAjsT/fTfBOkQEFCQ29z4DK2IWWMcksXFHKytI
	QljATWLHhw1ADRwcLAKqEjt/xoKYvAIeEhfWFkEsU5BYcO8t2wRG7gWMDKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxgv33THoH46oGi0OMAhyMSjy8xy1P+AuxJpYVV+YeYpTgYFYS4WV4
	c9xfiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+TJTv8hQTSE0tSs1NTC1KLYLJMHJxSDYwrsj+9
	D984423gjKhJs2LO3U0xdts5cfqb35OfLHNitL23f1r3jZt5FdckOz5oxAQkGy+8sO/1ff5s
	NxPOC5t97+mfFD4Tekf3zcmQqnfruqcvtTjRwpm67Ctn+3yWL5EHpJ++2hLfcvOszNcLF/aW
	LL3kHPuTy3mlv3ukxM49DxwMNq5ZsOL7KSWW4oxEQy3mouJEABaHH3TbAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for support max77686 regulator.
MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
volatege of regulator on max77686 chip with using regmap.

Signed-off-by: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes from v5
- Remove clock registering and handling from regulator driver.
- Seperate set_voltage_time_sel function for BUCKs supporting DVS.
- Use pdata's initial data directly, do not use additional variable.

v5
https://lkml.org/lkml/2012/5/28/293

 drivers/regulator/Kconfig    |    8 +
 drivers/regulator/Makefile   |    1 +
 drivers/regulator/max77686.c |  337 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 346 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/max77686.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 36db5a4..8e2ebad 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -195,6 +195,14 @@ config REGULATOR_MAX8998
 	  via I2C bus. The provided regulator is suitable for S3C6410
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
+config REGULATOR_MAX77686
+	tristate "Maxim 77686 regulator"
+	depends on MFD_MAX77686
+	help
+	  This driver controls a Maxim 77686 regulator
+	  via I2C bus. The provided regulator is suitable for
+	  Exynos-4 chips to control VARM and VINT voltages.
+
 config REGULATOR_PCAP
 	tristate "Motorola PCAP2 regulator driver"
 	depends on EZX_PCAP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 94b5274..008931b 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
 obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
+obj-$(CONFIG_REGULATOR_MAX77686) += max77686.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
new file mode 100644
index 0000000..70046f8
--- /dev/null
+++ b/drivers/regulator/max77686.c
@@ -0,0 +1,337 @@
+/*
+ * max77686.c - Regulator driver for the Maxim 77686
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Chiwoong Byun <woong.byun@smasung.com>
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This driver is based on max8997.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+
+#define MAX77686_LDO_MINUV	800000
+#define MAX77686_LDO_UVSTEP	50000
+#define MAX77686_LDO_LOW_MINUV	800000
+#define MAX77686_LDO_LOW_UVSTEP	25000
+#define MAX77686_BUCK_MINUV	750000
+#define MAX77686_BUCK_UVSTEP	50000
+#define MAX77686_DVS_MINUV	600000
+#define MAX77686_DVS_UVSTEP	12500
+
+#define MAX77686_OPMODE_SHIFT	6
+#define MAX77686_OPMODE_BUCK234_SHIFT	4
+#define MAX77686_OPMODE_MASK	0x3
+
+#define MAX77686_VSEL_MASK	0x3F
+#define MAX77686_DVS_VSEL_MASK	0xFF
+
+#define MAX77686_RAMP_RATE_MASK	0xC0
+
+#define MAX77686_REGULATORS	MAX77686_REG_MAX
+#define MAX77686_LDOS		26
+
+enum max77686_ramp_rate {
+	RAMP_RATE_13P75MV,
+	RAMP_RATE_27P5MV,
+	RAMP_RATE_55MV,
+	RAMP_RATE_NO_CTRL,	/* 100mV/us */
+};
+
+struct max77686_data {
+	struct device *dev;
+	struct max77686_dev *iodev;
+	int num_regulators;
+	struct regulator_dev **rdev;
+	int ramp_delay; /* in mV/us */
+};
+
+static int max77686_set_dvs_voltage_time_sel(struct regulator_dev *rdev,
+			unsigned int old_selector, unsigned int new_selector)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	int ramp_rate[] = {13, 27, 55, 100};
+	return (DIV_ROUND_UP(rdev->desc->uV_step
+			* abs(new_selector - old_selector),
+			ramp_rate[max77686->ramp_delay]));
+}
+
+static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
+			unsigned int old_selector, unsigned int new_selector)
+{
+	/* Unconditionally 100 mV/us */
+	return (DIV_ROUND_UP(rdev->desc->uV_step
+		 * abs(new_selector - old_selector), 100));
+}
+
+static struct regulator_ops max77686_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= max77686_set_voltage_time_sel,
+};
+
+static struct regulator_ops max77686_buck_dvs_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= max77686_set_dvs_voltage_time_sel,
+};
+
+#define regulator_desc_ldo(num)		{				\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_MINUV,				\
+	.uV_step	= MAX77686_LDO_UVSTEP,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
+#define regulator_desc_ldo_low(num)		{			\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_LOW_MINUV,			\
+	.uV_step	= MAX77686_LDO_LOW_UVSTEP,			\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
+#define regulator_desc_buck(num)		{			\
+	.name		= "BUCK"#num,					\
+	.id		= MAX77686_BUCK##num,				\
+	.ops		= &max77686_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_BUCK_MINUV,				\
+	.uV_step	= MAX77686_BUCK_UVSTEP,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_BUCK5OUT + (num - 5) * 2,	\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_BUCK5CTRL + (num - 5) * 2,	\
+	.enable_mask	= MAX77686_OPMODE_MASK,				\
+}
+#define regulator_desc_buck1(num)		{			\
+	.name		= "BUCK"#num,					\
+	.id		= MAX77686_BUCK##num,				\
+	.ops		= &max77686_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_BUCK_MINUV,				\
+	.uV_step	= MAX77686_BUCK_UVSTEP,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_BUCK1OUT,			\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_BUCK1CTRL,			\
+	.enable_mask	= MAX77686_OPMODE_MASK,				\
+}
+#define regulator_desc_buck_dvs(num)		{			\
+	.name		= "BUCK"#num,					\
+	.id		= MAX77686_BUCK##num,				\
+	.ops		= &max77686_buck_dvs_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_DVS_MINUV,				\
+	.uV_step	= MAX77686_DVS_UVSTEP,				\
+	.n_voltages	= MAX77686_DVS_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_BUCK2DVS1 + (num - 2) * 10,	\
+	.vsel_mask	= MAX77686_DVS_VSEL_MASK,			\
+	.enable_reg	= MAX77686_REG_BUCK2CTRL1 + (num - 2) * 10,	\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_BUCK234_SHIFT,		\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_ldo_low(1),
+	regulator_desc_ldo_low(2),
+	regulator_desc_ldo(3),
+	regulator_desc_ldo(4),
+	regulator_desc_ldo(5),
+	regulator_desc_ldo_low(6),
+	regulator_desc_ldo_low(7),
+	regulator_desc_ldo_low(8),
+	regulator_desc_ldo(9),
+	regulator_desc_ldo(10),
+	regulator_desc_ldo(11),
+	regulator_desc_ldo(12),
+	regulator_desc_ldo(13),
+	regulator_desc_ldo(14),
+	regulator_desc_ldo_low(15),
+	regulator_desc_ldo(16),
+	regulator_desc_ldo(17),
+	regulator_desc_ldo(18),
+	regulator_desc_ldo(19),
+	regulator_desc_ldo(20),
+	regulator_desc_ldo(21),
+	regulator_desc_ldo(22),
+	regulator_desc_ldo(23),
+	regulator_desc_ldo(24),
+	regulator_desc_ldo(25),
+	regulator_desc_ldo(26),
+	regulator_desc_buck1(1),
+	regulator_desc_buck_dvs(2),
+	regulator_desc_buck_dvs(3),
+	regulator_desc_buck_dvs(4),
+	regulator_desc_buck(5),
+	regulator_desc_buck(6),
+	regulator_desc_buck(7),
+	regulator_desc_buck(8),
+	regulator_desc_buck(9),
+};
+
+static __devinit int max77686_pmic_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_dev **rdev;
+	struct max77686_data *max77686;
+	int i,  size;
+	int ret = 0;
+	struct regulator_config config;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
+				GFP_KERNEL);
+	if (!max77686)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * MAX77686_REGULATORS;
+	max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!max77686->rdev)
+		return -ENOMEM;
+
+	rdev = max77686->rdev;
+	max77686->dev = &pdev->dev;
+	max77686->iodev = iodev;
+	if (pdata)
+		max77686->num_regulators = pdata->num_regulators;
+	platform_set_drvdata(pdev, max77686);
+
+	max77686->ramp_delay = RAMP_RATE_NO_CTRL; /* Set 0x3 for RAMP */
+	regmap_update_bits(max77686->iodev->regmap,
+			MAX77686_REG_BUCK2CTRL1, MAX77686_RAMP_RATE_MASK,
+			max77686->ramp_delay << 6);
+	regmap_update_bits(max77686->iodev->regmap,
+			MAX77686_REG_BUCK3CTRL1, MAX77686_RAMP_RATE_MASK,
+			max77686->ramp_delay << 6);
+	regmap_update_bits(max77686->iodev->regmap,
+			MAX77686_REG_BUCK4CTRL1, MAX77686_RAMP_RATE_MASK,
+			max77686->ramp_delay << 6);
+
+	if (pdata->num_regulators == MAX77686_REGULATORS) {
+		for (i = 0; i < MAX77686_REGULATORS; i++) {
+			config.dev = max77686->dev;
+			config.regmap = iodev->regmap;
+			config.driver_data = max77686;
+			config.init_data = pdata->regulators[i].initdata;
+
+			rdev[i] = regulator_register(&regulators[i], &config);
+
+			if (IS_ERR(rdev[i])) {
+				ret = PTR_ERR(rdev[i]);
+				dev_err(max77686->dev,
+				"regulator init failed for %d\n", i);
+				rdev[i] = NULL;
+				goto err;
+			}
+		}
+	} else {
+		dev_err(max77686->dev,
+			 "Lack of initial data for regulator's initialiation\n");
+		return -EINVAL;
+	}
+	return 0;
+err:
+	for (i = 0; i < MAX77686_REGULATORS; i++) {
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+	}
+	return ret;
+}
+
+static int __devexit max77686_pmic_remove(struct platform_device *pdev)
+{
+	struct max77686_data *max77686 = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = max77686->rdev;
+	int i;
+
+	for (i = 0; i < MAX77686_REGULATORS; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return 0;
+}
+
+static const struct platform_device_id max77686_pmic_id[] = {
+	{"max77686-pmic", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, max77686_pmic_id);
+
+static struct platform_driver max77686_pmic_driver = {
+	.driver = {
+		.name = "max77686-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = max77686_pmic_probe,
+	.remove = __devexit_p(max77686_pmic_remove),
+	.id_table = max77686_pmic_id,
+};
+
+static int __init max77686_pmic_init(void)
+{
+	return platform_driver_register(&max77686_pmic_driver);
+}
+subsys_initcall(max77686_pmic_init);
+
+static void __exit max77686_pmic_cleanup(void)
+{
+	platform_driver_unregister(&max77686_pmic_driver);
+}
+module_exit(max77686_pmic_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 77686 Regulator Driver");
+MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

