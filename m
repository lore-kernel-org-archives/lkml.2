Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2JPF2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:28:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56699 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2JPF2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:28:47 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-2e-507cf08eeb51
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 2/2] regulator: max77686: Add
 set_suspend_disable/set_suspend_mode callbacks.
Date: Tue, 16 Oct 2012 10:55:12 +0530
Message-id: <1350365112-18912-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWyRsSkVrfvQ02Awc5WdovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxv20ZW8FFy4rHa/uYGhh/6XUxcnJICJhIzLu5iwnCFpO4cG89
	G4gtJLCUUeLR4hCYmt55m1i6GLmA4tMZJZ5+XsII4SxnkjjS0czexcjBwSZgJPHqmB1Ig4iA
	gsTm3mesIDXMAjOZJJ5+e80KkhAWiJc4+Wsb2AYWAVWJnmc32EB6eQVcJd4c5oNYpiDRuuwQ
	O0SJgMS3yYdYQEokBGQlNh1gBhkpIbCHTWL7h+vMEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZgQJ3+90x6B+OqBotDjAIcjEo8vBnONQFCrIllxZW5hxglOJiV
	RHg9JgKFeFMSK6tSi/Lji0pzUosPMfoAXTKRWUo0OR8Y7Hkl8YbGJuamxqaWRkZmpqY4hJXE
	eZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MIo9nB4Tu//c2ejG1+vWbJ7ySeTQbe/dj8+o/H2W
	F+HkW3HqIGPg+vIfaw31Wc/9yakIP8z3yN894fDEGWxmUzPu3Wc83l5YrPDWr+vr/hu5mUlM
	27Y9kNUtq58euinqw6907cdfl3fP8lEzbv539MVb5QLvDQvW1elz3d095V7WnNSIj2K8Bzcp
	sRRnJBpqMRcVJwIAzaNQhFUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jQd3eDzUBBr2fTCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxv62ZWwFFy0rHq/tY2pg
	/KXXxcjJISFgItE7bxMLhC0mceHeerYuRi4OIYHpjBJPPy9hhHCWM0kc6Whm72Lk4GATMJJ4
	dcwOpEFEQEFic+8zVpAaZoGZTBJPv71mBUkIC8RLnPy1jQ3EZhFQleh5doMNpJdXwFXizWE+
	iGUKEq3LDrFPYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4YJ9J72Bc1WBxiFGA
	g1GJhzfDuSZAiDWxrLgy9xCjBAezkgivx0SgEG9KYmVValF+fFFpTmrxIUYfoOUTmaVEk/OB
	0ZRXEm9obGJuamxqaWJhYmaJQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA2Nacvmjw1uC
	K3Nbbh1e8kazZPv7azPaVmhWHLly8tLkznU+NtX+Te5M367yGBrKLJHmS1v7eokLs8LzxYxz
	ZZfVdS3auKcu/LvizNS58bvY/dUtEzoZ5u+1ONRpwugW0/L4lsj0qm9vtGQ1bXz+/ffYHfmm
	v07oEQ+f5PKFq75JbnfJET3Rd1SJpTgj0VCLuag4EQCthAkVhQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements set_suspend_disable callback for BUCKs which
support only switch ON/OFF modes during system suspend state, and
set_suspend_mode callbacks for LDOs which also suport Low power mode and
switch ON/OFF modes.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |  142 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 135 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 2a67d08..e83db38 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -69,6 +69,76 @@ struct max77686_data {
 	struct regulator_dev *rdev[MAX77686_REGULATORS];
 };
 
+/* Some BUCKS supports Normal[ON/OFF] mode during suspend */
+static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
+{
+	unsigned int val;
+
+	if (rdev->desc->id == MAX77686_BUCK1)
+		val = 0x1;
+	else
+		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  val);
+}
+
+/* Some LDOs supports [LPM/Normal]ON mode during suspend state */
+static int max77686_set_suspend_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
+{
+	unsigned int val;
+
+	/* BUCK[5-9] doesn't support this feature */
+	if (rdev->desc->id >= MAX77686_BUCK5)
+		return 0;
+
+	switch (mode) {
+	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
+		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		break;
+	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
+		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
+			rdev->desc->name, mode);
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  val);
+}
+
+/* Some LDOs supports LPM-ON/OFF/Normal-ON mode during suspend state */
+static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
+{
+	unsigned int val;
+
+	switch (mode) {
+	case REGULATOR_MODE_STANDBY:			/* switch off */
+		val = 0x1 << MAX77686_OPMODE_SHIFT;
+		break;
+	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
+		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		break;
+	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
+		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
+			rdev->desc->name, mode);
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  val);
+}
+
 static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	unsigned int ramp_value = RAMP_RATE_NO_CTRL;
@@ -103,6 +173,31 @@ static struct regulator_ops max77686_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_mode	= max77686_set_suspend_mode,
+};
+
+static struct regulator_ops max77686_ldo_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
+};
+
+static struct regulator_ops max77686_buck1_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_disable	= max77686_buck_set_suspend_disable,
 };
 
 static struct regulator_ops max77686_buck_dvs_ops = {
@@ -115,6 +210,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77686_set_ramp_delay,
+	.set_suspend_disable	= max77686_buck_set_suspend_disable,
 };
 
 #define regulator_desc_ldo(num)		{				\
@@ -133,9 +229,41 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.enable_mask	= MAX77686_OPMODE_MASK				\
 			<< MAX77686_OPMODE_SHIFT,			\
 }
+#define regulator_desc_lpm_ldo(num)	{				\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ldo_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_MINUV,				\
+	.uV_step	= MAX77686_LDO_UVSTEP,				\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
 #define regulator_desc_ldo_low(num)		{			\
 	.name		= "LDO"#num,					\
 	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ldo_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_LOW_MINUV,			\
+	.uV_step	= MAX77686_LDO_LOW_UVSTEP,			\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
+#define regulator_desc_ldo1_low(num)		{			\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
 	.owner		= THIS_MODULE,					\
@@ -167,7 +295,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 #define regulator_desc_buck1(num)		{			\
 	.name		= "BUCK"#num,					\
 	.id		= MAX77686_BUCK##num,				\
-	.ops		= &max77686_ops,				\
+	.ops		= &max77686_buck1_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_BUCK_MINUV,				\
@@ -197,7 +325,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 
 static struct regulator_desc regulators[] = {
-	regulator_desc_ldo_low(1),
+	regulator_desc_ldo1_low(1),
 	regulator_desc_ldo_low(2),
 	regulator_desc_ldo(3),
 	regulator_desc_ldo(4),
@@ -206,13 +334,13 @@ static struct regulator_desc regulators[] = {
 	regulator_desc_ldo_low(7),
 	regulator_desc_ldo_low(8),
 	regulator_desc_ldo(9),
-	regulator_desc_ldo(10),
-	regulator_desc_ldo(11),
-	regulator_desc_ldo(12),
+	regulator_desc_lpm_ldo(10),
+	regulator_desc_lpm_ldo(11),
+	regulator_desc_lpm_ldo(12),
 	regulator_desc_ldo(13),
-	regulator_desc_ldo(14),
+	regulator_desc_lpm_ldo(14),
 	regulator_desc_ldo_low(15),
-	regulator_desc_ldo(16),
+	regulator_desc_lpm_ldo(16),
 	regulator_desc_ldo(17),
 	regulator_desc_ldo(18),
 	regulator_desc_ldo(19),
-- 
1.7.0.4

