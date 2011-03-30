Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab1C3WRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:17:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10312 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1C3WRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:17:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6301"; a="82842303"
From: David Collins <collinsd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH 2/2] msm: board-8960: Add support for pm8921-regulator
Date: Wed, 30 Mar 2011 15:17:46 -0700
Message-Id: <1301523466-6054-1-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add board-msm8960-regulator.c to contain pm8921-regulator structure
declarations.  NULL consumer names in the regulator_consumer_supply
lists are used for debugging and as place holders.  They will
eventually be changed to use more appropriate debug device names.
The primary configuration table msm_pm8921_regulator_pdata specifies
the following characteristics for each regulator: if it is always on,
if it should have its pull down set when disabled, its min and max
voltage constraints, its supply regulator, and its pin control pins.

Signed-off-by: David Collins <collinsd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                  |    1 +
 arch/arm/mach-msm/board-msm8960-regulator.c |  303 +++++++++++++++++++++++++++
 arch/arm/mach-msm/board-msm8960.c           |    6 +
 arch/arm/mach-msm/board-msm8960.h           |   23 ++
 4 files changed, 333 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8960-regulator.c
 create mode 100644 arch/arm/mach-msm/board-msm8960.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index a4f55ec..c590fa9 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
 obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
+obj-$(CONFIG_ARCH_MSM8960) += board-msm8960-regulator.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-msm8960-regulator.c b/arch/arm/mach-msm/board-msm8960-regulator.c
new file mode 100644
index 0000000..0d1f5ab
--- /dev/null
+++ b/arch/arm/mach-msm/board-msm8960-regulator.c
@@ -0,0 +1,303 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/regulator/pm8921-regulator.h>
+
+#include "board-msm8960.h"
+
+#define VREG_CONSUMERS(_id) \
+	static struct regulator_consumer_supply \
+	pm8921_vreg_consumers_##_id[] __devinitdata
+
+/*
+ * Consumer specific regulator names:
+ *			 regulator name		consumer dev_name
+ */
+VREG_CONSUMERS(L1) = {
+	REGULATOR_SUPPLY("8921_l1",		NULL),
+};
+VREG_CONSUMERS(L2) = {
+	REGULATOR_SUPPLY("8921_l2",		NULL),
+};
+VREG_CONSUMERS(L3) = {
+	REGULATOR_SUPPLY("8921_l3",		NULL),
+	REGULATOR_SUPPLY("HSUSB_3p3",		"msm_otg"),
+};
+VREG_CONSUMERS(L4) = {
+	REGULATOR_SUPPLY("8921_l4",		NULL),
+	REGULATOR_SUPPLY("HSUSB_1p8",		"msm_otg"),
+};
+VREG_CONSUMERS(L5) = {
+	REGULATOR_SUPPLY("8921_l5",		NULL),
+	REGULATOR_SUPPLY("sdc_vdd",		"msm_sdcc.1"),
+};
+VREG_CONSUMERS(L6) = {
+	REGULATOR_SUPPLY("8921_l6",		NULL),
+	REGULATOR_SUPPLY("sdc_vdd",		"msm_sdcc.3"),
+};
+VREG_CONSUMERS(L7) = {
+	REGULATOR_SUPPLY("8921_l7",		NULL),
+	REGULATOR_SUPPLY("sdc_vddp",		"msm_sdcc.3"),
+};
+VREG_CONSUMERS(L8) = {
+	REGULATOR_SUPPLY("8921_l8",		NULL),
+};
+VREG_CONSUMERS(L9) = {
+	REGULATOR_SUPPLY("8921_l9",		NULL),
+};
+VREG_CONSUMERS(L10) = {
+	REGULATOR_SUPPLY("8921_l10",		NULL),
+};
+VREG_CONSUMERS(L11) = {
+	REGULATOR_SUPPLY("8921_l11",		NULL),
+};
+VREG_CONSUMERS(L12) = {
+	REGULATOR_SUPPLY("8921_l12",		NULL),
+};
+VREG_CONSUMERS(L14) = {
+	REGULATOR_SUPPLY("8921_l14",		NULL),
+};
+VREG_CONSUMERS(L15) = {
+	REGULATOR_SUPPLY("8921_l15",		NULL),
+};
+VREG_CONSUMERS(L16) = {
+	REGULATOR_SUPPLY("8921_l16",		NULL),
+};
+VREG_CONSUMERS(L17) = {
+	REGULATOR_SUPPLY("8921_l17",		NULL),
+};
+VREG_CONSUMERS(L18) = {
+	REGULATOR_SUPPLY("8921_l18",		NULL),
+};
+VREG_CONSUMERS(L21) = {
+	REGULATOR_SUPPLY("8921_l21",		NULL),
+};
+VREG_CONSUMERS(L22) = {
+	REGULATOR_SUPPLY("8921_l22",		NULL),
+};
+VREG_CONSUMERS(L23) = {
+	REGULATOR_SUPPLY("8921_l23",		NULL),
+};
+VREG_CONSUMERS(L24) = {
+	REGULATOR_SUPPLY("8921_l24",		NULL),
+};
+VREG_CONSUMERS(L25) = {
+	REGULATOR_SUPPLY("8921_l25",		NULL),
+};
+VREG_CONSUMERS(L26) = {
+	REGULATOR_SUPPLY("8921_l26",		NULL),
+};
+VREG_CONSUMERS(L27) = {
+	REGULATOR_SUPPLY("8921_l27",		NULL),
+};
+VREG_CONSUMERS(L28) = {
+	REGULATOR_SUPPLY("8921_l28",		NULL),
+};
+VREG_CONSUMERS(L29) = {
+	REGULATOR_SUPPLY("8921_l29",		NULL),
+};
+VREG_CONSUMERS(S1) = {
+	REGULATOR_SUPPLY("8921_s1",		NULL),
+};
+VREG_CONSUMERS(S2) = {
+	REGULATOR_SUPPLY("8921_s2",		NULL),
+};
+VREG_CONSUMERS(S3) = {
+	REGULATOR_SUPPLY("8921_s3",		NULL),
+	REGULATOR_SUPPLY("HSUSB_VDDCX",		"msm_otg"),
+};
+VREG_CONSUMERS(S4) = {
+	REGULATOR_SUPPLY("8921_s4",		NULL),
+	REGULATOR_SUPPLY("sdc_vccq",		"msm_sdcc.1"),
+};
+VREG_CONSUMERS(S5) = {
+	REGULATOR_SUPPLY("8921_s5",		NULL),
+};
+VREG_CONSUMERS(S6) = {
+	REGULATOR_SUPPLY("8921_s6",		NULL),
+};
+VREG_CONSUMERS(S7) = {
+	REGULATOR_SUPPLY("8921_s7",		NULL),
+};
+VREG_CONSUMERS(S8) = {
+	REGULATOR_SUPPLY("8921_s8",		NULL),
+};
+VREG_CONSUMERS(LVS1) = {
+	REGULATOR_SUPPLY("8921_lvs1",		NULL),
+	REGULATOR_SUPPLY("sdc_vdd",		"msm_sdcc.4"),
+};
+VREG_CONSUMERS(LVS2) = {
+	REGULATOR_SUPPLY("8921_lvs2",		NULL),
+};
+VREG_CONSUMERS(LVS3) = {
+	REGULATOR_SUPPLY("8921_lvs3",		NULL),
+};
+VREG_CONSUMERS(LVS4) = {
+	REGULATOR_SUPPLY("8921_lvs4",		NULL),
+};
+VREG_CONSUMERS(LVS5) = {
+	REGULATOR_SUPPLY("8921_lvs5",		NULL),
+};
+VREG_CONSUMERS(LVS6) = {
+	REGULATOR_SUPPLY("8921_lvs6",		NULL),
+};
+VREG_CONSUMERS(LVS7) = {
+	REGULATOR_SUPPLY("8921_lvs7",		NULL),
+};
+VREG_CONSUMERS(USB_OTG) = {
+	REGULATOR_SUPPLY("8921_usb_otg",	NULL),
+};
+VREG_CONSUMERS(HDMI_MVS) = {
+	REGULATOR_SUPPLY("8921_hdmi_mvs",	NULL),
+};
+VREG_CONSUMERS(NCP) = {
+	REGULATOR_SUPPLY("8921_ncp",		NULL),
+};
+
+#define PM8921_VREG_INIT(_id, _min_uV, _max_uV, _modes, _ops, _apply_uV, \
+			 _pull_down, _pin_ctrl, _pin_fn, _always_on, \
+			 _supply_regulator) \
+	{ \
+		.init_data		= { \
+			.constraints		= { \
+				.valid_modes_mask	= _modes, \
+				.valid_ops_mask		= _ops, \
+				.min_uV			= _min_uV, \
+				.max_uV			= _max_uV, \
+				.input_uV		= _max_uV, \
+				.apply_uV		= _apply_uV, \
+				.always_on		= _always_on, \
+			}, \
+			.num_consumer_supplies	= \
+				ARRAY_SIZE(pm8921_vreg_consumers_##_id), \
+			.consumer_supplies	= pm8921_vreg_consumers_##_id, \
+			.supply_regulator	= _supply_regulator, \
+		}, \
+		.id			= PM8921_VREG_ID_##_id, \
+		.pull_down_enable	= _pull_down, \
+		.pin_ctrl		= _pin_ctrl, \
+		.pin_fn			= _pin_fn, \
+	}
+
+#define PM8921_VREG_INIT_LDO(_id, _always_on, _pull_down, _min_uV, _max_uV, \
+		_supply_regulator, _pin_ctrl) \
+	PM8921_VREG_INIT(_id, _min_uV, _max_uV, REGULATOR_MODE_FAST | \
+		REGULATOR_MODE_NORMAL | REGULATOR_MODE_IDLE | \
+		REGULATOR_MODE_STANDBY, REGULATOR_CHANGE_VOLTAGE | \
+		REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE | \
+		REGULATOR_CHANGE_DRMS, 0, _pull_down, _pin_ctrl, \
+		PM8921_VREG_PIN_FN_ENABLE, _always_on, _supply_regulator)
+
+#define PM8921_VREG_INIT_NLDO1200(_id, _always_on, _pull_down, _min_uV, \
+		_max_uV, _supply_regulator) \
+	PM8921_VREG_INIT(_id, _min_uV, _max_uV, REGULATOR_MODE_FAST | \
+		REGULATOR_MODE_STANDBY, REGULATOR_CHANGE_VOLTAGE | \
+		REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE | \
+		REGULATOR_CHANGE_DRMS, 0, _pull_down, \
+		PM8921_VREG_PIN_CTRL_NONE, PM8921_VREG_PIN_FN_ENABLE, \
+		_always_on, _supply_regulator)
+
+#define PM8921_VREG_INIT_SMPS(_id, _always_on, _pull_down, _min_uV, _max_uV, \
+		_supply_regulator, _pin_ctrl) \
+	PM8921_VREG_INIT(_id, _min_uV, _max_uV, REGULATOR_MODE_FAST | \
+		REGULATOR_MODE_NORMAL | REGULATOR_MODE_IDLE | \
+		REGULATOR_MODE_STANDBY, REGULATOR_CHANGE_VOLTAGE | \
+		REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE | \
+		REGULATOR_CHANGE_DRMS, 0, _pull_down, _pin_ctrl, \
+		PM8921_VREG_PIN_FN_ENABLE, _always_on, _supply_regulator)
+
+#define PM8921_VREG_INIT_FTSMPS(_id, _always_on, _pull_down, _min_uV, _max_uV, \
+		_supply_regulator) \
+	PM8921_VREG_INIT(_id, _min_uV, _max_uV, REGULATOR_MODE_FAST | \
+		REGULATOR_MODE_STANDBY, REGULATOR_CHANGE_VOLTAGE | \
+		REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE | \
+		REGULATOR_CHANGE_DRMS, 0, _pull_down, \
+		PM8921_VREG_PIN_CTRL_NONE, PM8921_VREG_PIN_FN_ENABLE, \
+		_always_on, _supply_regulator)
+
+#define PM8921_VREG_INIT_VS(_id, _always_on, _pull_down, _supply_regulator, \
+		_pin_ctrl) \
+	PM8921_VREG_INIT(_id, 0, 0, REGULATOR_MODE_NORMAL | \
+		REGULATOR_MODE_IDLE, REGULATOR_CHANGE_STATUS | \
+		REGULATOR_CHANGE_MODE, 0, _pull_down, _pin_ctrl, \
+		PM8921_VREG_PIN_FN_ENABLE, _always_on, _supply_regulator)
+
+#define PM8921_VREG_INIT_VS300(_id, _always_on, _pull_down, _supply_regulator) \
+	PM8921_VREG_INIT(_id, 0, 0, 0, REGULATOR_CHANGE_STATUS, 0, _pull_down, \
+		PM8921_VREG_PIN_CTRL_NONE, PM8921_VREG_PIN_FN_ENABLE, \
+		_always_on, _supply_regulator)
+
+#define PM8921_VREG_INIT_NCP(_id, _always_on, _pull_down, _min_uV, _max_uV, \
+		_supply_regulator) \
+	PM8921_VREG_INIT(_id, _min_uV, _max_uV, REGULATOR_MODE_NORMAL | \
+		REGULATOR_MODE_IDLE, REGULATOR_CHANGE_VOLTAGE | \
+		REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE | \
+		REGULATOR_CHANGE_DRMS, 0, _pull_down, \
+		PM8921_VREG_PIN_CTRL_NONE, PM8921_VREG_PIN_FN_ENABLE, \
+		_always_on, _supply_regulator)
+
+/* Regulator constraints */
+struct pm8921_regulator_platform_data
+msm_pm8921_regulator_pdata[] __devinitdata = {
+	PM8921_VREG_INIT_SMPS(S1, 0, 0, 1225000, 1225000, NULL,      0),
+	PM8921_VREG_INIT_SMPS(S2, 0, 0, 1300000, 1300000, NULL,      0),
+	PM8921_VREG_INIT_SMPS(S3, 0, 0, 1050000, 1050000, NULL,      0),
+	PM8921_VREG_INIT_SMPS(S4, 0, 0, 1800000, 1800000, NULL,      0),
+	PM8921_VREG_INIT_FTSMPS(S5, 0, 0, 1050000, 1050000, NULL),
+	PM8921_VREG_INIT_FTSMPS(S6, 0, 0, 1050000, 1050000, NULL),
+	PM8921_VREG_INIT_SMPS(S7, 0, 0, 1150000, 1150000, NULL,      0),
+	PM8921_VREG_INIT_SMPS(S8, 0, 0, 2200000, 2200000, NULL,      0),
+
+	PM8921_VREG_INIT_LDO(L1,  0, 0, 1050000, 1050000, "8921_s4", 0),
+	PM8921_VREG_INIT_LDO(L2,  0, 0, 1200000, 1200000, "8921_s4", 0),
+	PM8921_VREG_INIT_LDO(L3,  0, 0, 3075000, 3075000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L4,  0, 0, 1800000, 1800000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L5,  0, 0, 2950000, 2950000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L6,  0, 0, 2950000, 2950000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L7,  0, 0, 2950000, 2950000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L8,  0, 0, 3000000, 3000000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L9,  0, 0, 2850000, 2850000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L10, 0, 0, 2900000, 2900000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L11, 0, 0, 2850000, 2850000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L12, 0, 0, 1200000, 1200000, "8921_s4", 0),
+	PM8921_VREG_INIT_LDO(L14, 0, 0, 1800000, 1800000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L15, 0, 0, 1800000, 2950000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L16, 0, 0, 3000000, 3000000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L17, 0, 0, 1800000, 2950000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L18, 0, 0, 1300000, 1300000, "8921_s4", 0),
+	PM8921_VREG_INIT_LDO(L21, 0, 0, 1900000, 1900000, "8921_s8", 0),
+	PM8921_VREG_INIT_LDO(L22, 0, 0, 2750000, 2750000, NULL,      0),
+	PM8921_VREG_INIT_LDO(L23, 0, 0, 1800000, 1800000, "8921_s8", 0),
+	PM8921_VREG_INIT_NLDO1200(L24, 0, 0, 1050000, 1050000, "8921_s1"),
+	PM8921_VREG_INIT_NLDO1200(L25, 0, 0, 1225000, 1225000, "8921_s1"),
+	PM8921_VREG_INIT_NLDO1200(L26, 0, 0, 1050000, 1050000, "8921_s7"),
+	PM8921_VREG_INIT_NLDO1200(L27, 0, 0, 1050000, 1050000, "8921_s7"),
+	PM8921_VREG_INIT_NLDO1200(L28, 0, 0, 1050000, 1050000, "8921_s7"),
+	PM8921_VREG_INIT_LDO(L29, 0, 0, 2050000, 2100000, "8921_s8", 0),
+
+	PM8921_VREG_INIT_VS(LVS1, 0, 0,			  "8921_s4", 0),
+	PM8921_VREG_INIT_VS300(LVS2, 0, 0,			  "8921_s1"),
+	PM8921_VREG_INIT_VS(LVS3, 0, 0,			  "8921_s4", 0),
+	PM8921_VREG_INIT_VS(LVS4, 0, 0,			  "8921_s4", 0),
+	PM8921_VREG_INIT_VS(LVS5, 0, 0,			  "8921_s4", 0),
+	PM8921_VREG_INIT_VS(LVS6, 0, 0,			  "8921_s4", 0),
+	PM8921_VREG_INIT_VS(LVS7, 0, 0,			  "8921_s4", 0),
+
+	PM8921_VREG_INIT_VS300(USB_OTG,  0, 0,		  NULL),
+	PM8921_VREG_INIT_VS300(HDMI_MVS, 0, 0,		  NULL),
+
+	PM8921_VREG_INIT_NCP(NCP, 0, 0, 1800000, 1800000, "8921_l6"),
+};
+
+int msm_pm8921_regulator_pdata_len __devinitdata =
+	ARRAY_SIZE(msm_pm8921_regulator_pdata);
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 1c90789..5cd2c79 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -27,6 +27,7 @@
 #include <mach/irqs.h>
 
 #include "devices.h"
+#include "board-msm8960.h"
 
 /* Macros assume PMIC GPIOs and MPPs start at 1 */
 #define PM8921_GPIO_BASE		NR_GPIO_IRQS
@@ -91,6 +92,7 @@ static struct pm8921_platform_data pm8921_platform_data __devinitdata = {
 	.irq_pdata		= &pm8xxx_irq_pdata,
 	.gpio_pdata		= &pm8xxx_gpio_pdata,
 	.mpp_pdata		= &pm8xxx_mpp_pdata,
+	.regulator_pdatas	= msm_pm8921_regulator_pdata,
 };
 
 static struct msm_ssbi_platform_data msm8960_ssbi_pm8921_pdata __initdata = {
@@ -107,6 +109,8 @@ static void __init msm8960_sim_init(void)
 	msm8960_device_ssbi_pm8921.dev.platform_data =
 					&msm8960_ssbi_pm8921_pdata;
 
+	pm8921_platform_data.num_regulators = msm_pm8921_regulator_pdata_len;
+
 	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
 }
 
@@ -116,6 +120,8 @@ static void __init msm8960_rumi3_init(void)
 	msm8960_device_ssbi_pm8921.dev.platform_data =
 					&msm8960_ssbi_pm8921_pdata;
 
+	pm8921_platform_data.num_regulators = msm_pm8921_regulator_pdata_len;
+
 	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
 }
 
diff --git a/arch/arm/mach-msm/board-msm8960.h b/arch/arm/mach-msm/board-msm8960.h
new file mode 100644
index 0000000..040b033
--- /dev/null
+++ b/arch/arm/mach-msm/board-msm8960.h
@@ -0,0 +1,23 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_BOARD_MSM8960_H
+#define __ARCH_ARM_MACH_MSM_BOARD_MSM8960_H
+
+#include <linux/mfd/pm8xxx/pm8921.h>
+
+extern struct pm8921_regulator_platform_data
+	msm_pm8921_regulator_pdata[] __devinitdata;
+
+extern int msm_pm8921_regulator_pdata_len __devinitdata;
+
+#endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

