Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0GMOKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:10:04 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:32844 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774Ab0GMOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:10:02 -0400
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <STEricsson_nomadik_linux@list.st.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific data
Date: Tue, 13 Jul 2010 19:39:33 +0530
Message-ID: <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sundar R Iyer <sundar.iyer@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/Makefile                  |    1 +
 arch/arm/mach-ux500/board-mop500-regulators.c |  189 +++++++++++++++++++++++++
 2 files changed, 190 insertions(+), 0 deletions(-)
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
index 0000000..34d16c6
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -0,0 +1,189 @@
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
+	{ .supply = "vaux1", },
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
+	{ .supply = "vaux2", },
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
+	{ .supply = "vaux3", },
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
+	{ .supply = "vtvout", },
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
+	{ .supply = "vaudio", },
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
+	{ .supply = "vana-mic1", },
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
+	{ .supply = "vana-mic2", },
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
+	{ .supply = "vdig-mic", },
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
+	{ .supply = "vintcore", },
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
+	{ .supply = "vana", },
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

