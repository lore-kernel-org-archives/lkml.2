Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0GMQNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:13:55 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51225 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755931Ab0GMQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:13:54 -0400
Date: Tue, 13 Jul 2010 21:43:44 +0530
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100713161343.GA25342@bnru01.bnr.st.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100713150905.GD24626@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

> Yes, if you don't have any actual devices to supply.
Please find the updated patch below.

>From 824b75ee4a38014fad6e17dd6d69bd3913053b45 Mon Sep 17 00:00:00 2001
From: Sundar R Iyer <sundar.iyer@stericsson.com>
Date: Sun, 6 Jun 2010 19:16:03 +0530
Subject: [PATCH v3 2/2] ux500: add ab8500-regulators machine specific data

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
CHANGELOG

v2 -> v3 
 - Empty the regulator_consumer_supply since there is no actual
   device to supply

v1 -> v2
 - Removed NULL device reference

 arch/arm/mach-ux500/Makefile                  |    1 +
 arch/arm/mach-ux500/board-mop500-regulators.c |  179 +++++++++++++++++++++++++
 2 files changed, 180 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-regulators.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 0753a69..311f996 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_HOTPLUG_CPU)       += hotplug.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
 obj-$(CONFIG_AB8500_PRCMU_I2C)	+= ab8500-prcmu-i2c.o
+obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
new file mode 100644
index 0000000..08bc966
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *
+ * MOP500 board specific initialization for regulators
+ */
+#include <linux/kernel.h>
+#include <linux/regulator/machine.h>
+
+static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vaux1_regulator = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaux1",
+		.min_uV = 1100000,
+		.max_uV = 3300000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
+	.consumer_supplies = ab8500_vaux1_consumers,
+};
+
+static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vaux2_regulator = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaux2",
+		.min_uV = 1100000,
+		.max_uV = 3300000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux2_consumers),
+	.consumer_supplies = ab8500_vaux2_consumers,
+};
+
+static struct regulator_consumer_supply ab8500_vaux3_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vaux3_regulator = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaux3",
+		.min_uV = 1100000,
+		.max_uV = 3300000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux3_consumers),
+	.consumer_supplies = ab8500_vaux3_consumers,
+};
+
+/* supply for tvout, gpadc, TVOUT LDO */
+static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vtvout_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vtvout",
+		.min_uV = 1900000,
+		.max_uV = 2100000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vtvout_consumers),
+	.consumer_supplies = ab8500_vtvout_consumers,
+};
+
+/* supply for ab8500-vaudio, VAUDIO LDO */
+static struct regulator_consumer_supply ab8500_vaudio_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vaudio_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaudio",
+		.min_uV = 1925000,
+		.max_uV = 2075000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaudio_consumers),
+	.consumer_supplies = ab8500_vaudio_consumers,
+};
+
+/* supply for v-anamic1 VAMic1-LDO */
+static struct regulator_consumer_supply ab8500_vamic1_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vamic1_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vamic1",
+		.min_uV = 2000000,
+		.max_uV = 2100000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic1_consumers),
+	.consumer_supplies = ab8500_vamic1_consumers,
+};
+
+/* supply for v-amic2, VAMIC2 LDO*/
+static struct regulator_consumer_supply ab8500_vamic2_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vamic2_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vamic2",
+		.min_uV = 2000000,
+		.max_uV = 2100000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
+	.consumer_supplies = ab8500_vamic2_consumers,
+};
+
+/* supply for v-dmic, VDMIC LDO */
+static struct regulator_consumer_supply ab8500_vdmic_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vdmic_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vdmic",
+		.min_uV = 1700000,
+		.max_uV = 1950000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vdmic_consumers),
+	.consumer_supplies = ab8500_vdmic_consumers,
+};
+
+/* supply for v-intcore12, VINTCORE12 LDO */
+static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vintcore_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vintcore",
+		.min_uV = 1200000,
+		.max_uV = 1350000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
+	.consumer_supplies = ab8500_vintcore_consumers,
+};
+
+/* supply for U8500 CSI/DSI, VANA LDO */
+static struct regulator_consumer_supply ab8500_vana_consumers[] = {
+};
+
+struct regulator_init_data ab8500_vana_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vana",
+		.min_uV = 0,
+		.max_uV = 1200000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
+	.consumer_supplies = ab8500_vana_consumers,
+};
+
-- 
1.7.0

