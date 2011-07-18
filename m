Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1GRGIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 02:08:20 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:45093 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1GRGIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 02:08:18 -0400
X-ASG-Debug-ID: 1310969298-082dd87f0001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, haojian.zhuang@marvell.com,
        nicolas.pitre@linaro.org, Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH] ARM: mmp/brownstone: add regulator init data for max8925
Subject: [PATCH] ARM: mmp/brownstone: add regulator init data for max8925
Date: Mon, 18 Jul 2011 14:10:10 +0800
X-ASG-Orig-Subj: [PATCH] ARM: mmp/brownstone: add regulator init data for max8925
Message-Id: <1310969410-451-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1310969298
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pmic max8925's init data for brownstone board.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm/mach-mmp/brownstone.c |  121 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
index 7bb78fd..4544be5 100644
--- a/arch/arm/mach-mmp/brownstone.c
+++ b/arch/arm/mach-mmp/brownstone.c
@@ -158,8 +158,127 @@ static struct platform_device brownstone_v_5vp_device = {
 	},
 };
 
+static struct regulator_consumer_supply brownstone_max8925_reg_supply[] = {
+	[MAX8925_ID_SD1]	= REGULATOR_SUPPLY("v_sd1",   NULL),
+	[MAX8925_ID_SD2]	= REGULATOR_SUPPLY("v_sd2",   NULL),
+	[MAX8925_ID_SD3]	= REGULATOR_SUPPLY("v_sd3",   NULL),
+	[MAX8925_ID_LDO1]	= REGULATOR_SUPPLY("v_ldo1",  NULL),
+	[MAX8925_ID_LDO2]	= REGULATOR_SUPPLY("v_ldo2",  NULL),
+	[MAX8925_ID_LDO3]	= REGULATOR_SUPPLY("v_ldo3",  NULL),
+	[MAX8925_ID_LDO4]	= REGULATOR_SUPPLY("v_ldo4",  NULL),
+	[MAX8925_ID_LDO5]	= REGULATOR_SUPPLY("v_ldo5",  NULL),
+	[MAX8925_ID_LDO6]	= REGULATOR_SUPPLY("v_ldo6",  NULL),
+	[MAX8925_ID_LDO7]	= REGULATOR_SUPPLY("v_ldo7",  NULL),
+	[MAX8925_ID_LDO8]	= REGULATOR_SUPPLY("v_ldo8",  NULL),
+	[MAX8925_ID_LDO9]	= REGULATOR_SUPPLY("v_ldo9",  NULL),
+	[MAX8925_ID_LDO10]	= REGULATOR_SUPPLY("v_ldo10", NULL),
+	[MAX8925_ID_LDO11]	= REGULATOR_SUPPLY("v_ldo11", NULL),
+	[MAX8925_ID_LDO12]	= REGULATOR_SUPPLY("v_ldo12", NULL),
+	[MAX8925_ID_LDO13]	= REGULATOR_SUPPLY("v_ldo13", NULL),
+	[MAX8925_ID_LDO14]	= REGULATOR_SUPPLY("v_ldo14", NULL),
+	[MAX8925_ID_LDO15]	= REGULATOR_SUPPLY("v_ldo15", NULL),
+	[MAX8925_ID_LDO16]	= REGULATOR_SUPPLY("v_ldo16", NULL),
+	[MAX8925_ID_LDO17]	= REGULATOR_SUPPLY("v_ldo17", NULL),
+	[MAX8925_ID_LDO18]	= REGULATOR_SUPPLY("v_ldo18", NULL),
+	[MAX8925_ID_LDO19]	= REGULATOR_SUPPLY("v_ldo19", NULL),
+	[MAX8925_ID_LDO20]	= REGULATOR_SUPPLY("v_ldo20", NULL),
+};
+
+#define MAX8925_REG_INIT(_name, _id, _min, _max, _always, _boot)	\
+static struct regulator_init_data max8925_reg_init_##_name =		\
+{									\
+	.constraints = {						\
+		.name		= __stringify(_name),			\
+		.min_uV		= _min,					\
+		.max_uV		= _max,					\
+		.always_on	= _always,				\
+		.boot_on	= _boot,				\
+		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE |		\
+				  REGULATOR_CHANGE_STATUS,		\
+	},								\
+	.num_consumer_supplies = 1,					\
+	.consumer_supplies = &brownstone_max8925_reg_supply[_id],	\
+}
+
+/*
+ * brownstone's pmic max8925 power domain usage;
+ *
+ * domain  voltage     usage
+ * ------  ---------   -------------------------------------------------
+ * sd1     1.2v        ddr3 termination regulator
+ * sd2     1.8v        soc gpio / 1.8v pheripherals / memories
+ * sd3     2.8v        soc gpio / 2.8v pheripherals / memories
+ * ldo1    2.8v        pmic max8925 adc
+ * ldo2    1.8v        soc plls / hdmi / hsic to usb hub
+ * ldo3    off/1.2v    soc mipi / mipi pheripheral i/o / mipi dsi bridge
+ * ldo4    3.3v        soc usb / hdmi / hsic to usb hub
+ * ldo5    off/1.2v    soc hsic / hsic to usb hub
+ * ldo6    off         unused
+ * ldo7    off         unused
+ * ldo8    off/3.0v    compass / accelerometer
+ * ldo9    1.8v        soc pmic max8649 / jtag / slimbus
+ * ldo10   off/1.8v    vibrator motor
+ * ldo11   off/3.0v    soc mmc1 / mmc/sd card
+ * ldo12   1.8v/off    unused
+ * ldo13   off/1.5v    camera digital
+ * ldo14   off/3.0v    camera auto focus
+ * ldo15   off/2.8v    camera analog
+ * ldo16   off         unused
+ * ldo17   off/1.2v    mipi dsi bridge / 32k clk
+ * ldo18   off         unused
+ * ldo19   off         unused
+ * ldo20   off         unused
+ */
+MAX8925_REG_INIT(sd1,   MAX8925_ID_SD1,   637500, 1425000, 1, 1);
+MAX8925_REG_INIT(sd2,   MAX8925_ID_SD2,   650000, 2225000, 1, 1);
+MAX8925_REG_INIT(sd3,   MAX8925_ID_SD3,   750000, 3900000, 1, 1);
+MAX8925_REG_INIT(ldo1,  MAX8925_ID_LDO1,  750000, 3900000, 1, 1);
+MAX8925_REG_INIT(ldo2,  MAX8925_ID_LDO2,  650000, 2250000, 1, 1);
+MAX8925_REG_INIT(ldo3,  MAX8925_ID_LDO3,  650000, 2250000, 0, 0);
+MAX8925_REG_INIT(ldo4,  MAX8925_ID_LDO4,  750000, 3900000, 1, 1);
+MAX8925_REG_INIT(ldo5,  MAX8925_ID_LDO5,  750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo6,  MAX8925_ID_LDO6,  750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo7,  MAX8925_ID_LDO7,  750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo8,  MAX8925_ID_LDO8,  750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo9,  MAX8925_ID_LDO9,  750000, 3900000, 1, 1);
+MAX8925_REG_INIT(ldo10, MAX8925_ID_LDO10, 750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo11, MAX8925_ID_LDO11, 750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo12, MAX8925_ID_LDO12, 750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo13, MAX8925_ID_LDO13, 750000, 1500000, 0, 0);
+MAX8925_REG_INIT(ldo14, MAX8925_ID_LDO14, 750000, 3000000, 0, 0);
+MAX8925_REG_INIT(ldo15, MAX8925_ID_LDO15, 750000, 2800000, 0, 0);
+MAX8925_REG_INIT(ldo16, MAX8925_ID_LDO16, 750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo17, MAX8925_ID_LDO17, 650000, 2250000, 1, 1);
+MAX8925_REG_INIT(ldo18, MAX8925_ID_LDO18, 650000, 2250000, 0, 0);
+MAX8925_REG_INIT(ldo19, MAX8925_ID_LDO19, 750000, 3900000, 0, 0);
+MAX8925_REG_INIT(ldo20, MAX8925_ID_LDO20, 750000, 3900000, 0, 0);
+
 static struct max8925_platform_data brownstone_max8925_info = {
-	.irq_base		= IRQ_BOARD_START,
+	.irq_base = IRQ_BOARD_START,
+
+	.regulator[MAX8925_ID_SD1]   = &max8925_reg_init_sd1,
+	.regulator[MAX8925_ID_SD2]   = &max8925_reg_init_sd2,
+	.regulator[MAX8925_ID_SD3]   = &max8925_reg_init_sd3,
+	.regulator[MAX8925_ID_LDO1]  = &max8925_reg_init_ldo1,
+	.regulator[MAX8925_ID_LDO2]  = &max8925_reg_init_ldo2,
+	.regulator[MAX8925_ID_LDO3]  = &max8925_reg_init_ldo3,
+	.regulator[MAX8925_ID_LDO4]  = &max8925_reg_init_ldo4,
+	.regulator[MAX8925_ID_LDO5]  = &max8925_reg_init_ldo5,
+	.regulator[MAX8925_ID_LDO6]  = &max8925_reg_init_ldo6,
+	.regulator[MAX8925_ID_LDO7]  = &max8925_reg_init_ldo7,
+	.regulator[MAX8925_ID_LDO8]  = &max8925_reg_init_ldo8,
+	.regulator[MAX8925_ID_LDO9]  = &max8925_reg_init_ldo9,
+	.regulator[MAX8925_ID_LDO10] = &max8925_reg_init_ldo10,
+	.regulator[MAX8925_ID_LDO11] = &max8925_reg_init_ldo11,
+	.regulator[MAX8925_ID_LDO12] = &max8925_reg_init_ldo12,
+	.regulator[MAX8925_ID_LDO13] = &max8925_reg_init_ldo13,
+	.regulator[MAX8925_ID_LDO14] = &max8925_reg_init_ldo14,
+	.regulator[MAX8925_ID_LDO15] = &max8925_reg_init_ldo15,
+	.regulator[MAX8925_ID_LDO16] = &max8925_reg_init_ldo16,
+	.regulator[MAX8925_ID_LDO17] = &max8925_reg_init_ldo17,
+	.regulator[MAX8925_ID_LDO18] = &max8925_reg_init_ldo18,
+	.regulator[MAX8925_ID_LDO19] = &max8925_reg_init_ldo19,
+	.regulator[MAX8925_ID_LDO20] = &max8925_reg_init_ldo20,
 };
 
 static struct i2c_board_info brownstone_twsi1_info[] = {
-- 
1.7.4.1

