Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0GMGt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:49:57 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59787 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab0GMGtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:49:55 -0400
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 02:49:53 EDT
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <STEricsson_nomadik_linux@list.st.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Acked-By: Bengt JONSSON" <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 3/3] ux500: add ab8500-regulators machine specific data
Date: Tue, 13 Jul 2010 11:51:30 +0530
Message-ID: <1279002090-11234-4-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
References: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sundar R Iyer <sundar.iyer@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-By: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/Makefile                  |    1 +
 arch/arm/mach-ux500/board-mop500-regulators.c |  214 +++++++++++++++++++++++++
 2 files changed, 215 insertions(+), 0 deletions(-)
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
index 0000000..8a10ad0
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ *
+ * MOP500 board specific initialization for regulators
+ */
+#include <linux/kernel.h>
+#include <linux/regulator/machine.h>
+
+#define AB8500_VAUXN_LDO_MIN_VOLTAGE    (1100000)
+#define AB8500_VAUXN_LDO_MAX_VOLTAGE    (3300000)
+
+static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
+	{ .dev = NULL, .supply = "vaux1", },
+};
+
+struct regulator_init_data ab8500_vaux1_regulator = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaux1",
+		.min_uV = AB8500_VAUXN_LDO_MIN_VOLTAGE,
+		.max_uV = AB8500_VAUXN_LDO_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
+	.consumer_supplies = ab8500_vaux1_consumers,
+};
+
+static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
+	{ .dev = NULL, .supply = "vaux2", },
+};
+
+struct regulator_init_data ab8500_vaux2_regulator = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaux2",
+		.min_uV = AB8500_VAUXN_LDO_MIN_VOLTAGE,
+		.max_uV = AB8500_VAUXN_LDO_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux2_consumers),
+	.consumer_supplies = ab8500_vaux2_consumers,
+};
+
+static struct regulator_consumer_supply ab8500_vaux3_consumers[] = {
+	{ .dev = NULL, .supply = "vaux3", },
+};
+
+struct regulator_init_data ab8500_vaux3_regulator = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaux3",
+		.min_uV = AB8500_VAUXN_LDO_MIN_VOLTAGE,
+		.max_uV = AB8500_VAUXN_LDO_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux3_consumers),
+	.consumer_supplies = ab8500_vaux3_consumers,
+};
+
+/* supply for tvout, gpadc, TVOUT LDO */
+#define AB8500_VTVOUT_LDO_MIN_VOLTAGE        (1900000)
+#define AB8500_VTVOUT_LDO_MAX_VOLTAGE        (2100000)
+
+static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
+	{ .dev = NULL, .supply = "vtvout", },
+};
+
+struct regulator_init_data ab8500_vtvout_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vtvout",
+		.min_uV = AB8500_VTVOUT_LDO_MIN_VOLTAGE,
+		.max_uV = AB8500_VTVOUT_LDO_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vtvout_consumers),
+	.consumer_supplies = ab8500_vtvout_consumers,
+};
+
+
+
+/* supply for ab8500-vaudio, VAUDIO LDO */
+#define AB8500_VAUDIO_REGULATOR_MIN_VOLTAGE        (1925000)
+#define AB8500_VAUDIO_REGULATOR_MAX_VOLTAGE        (2075000)
+
+static struct regulator_consumer_supply ab8500_vaudio_consumers[] = {
+	{  .dev = NULL, .supply = "vaudio", },
+};
+
+struct regulator_init_data ab8500_vaudio_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vaudio",
+		.min_uV = AB8500_VAUDIO_REGULATOR_MIN_VOLTAGE,
+		.max_uV = AB8500_VAUDIO_REGULATOR_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaudio_consumers),
+	.consumer_supplies = ab8500_vaudio_consumers,
+};
+
+
+/* supply for v-anamic1 VAMic1-LDO */
+#define AB8500_VAMIC1_REGULATOR_MIN_VOLTAGE        (2000000)
+#define AB8500_VAMIC1_REGULATOR_MAX_VOLTAGE        (2100000)
+
+static struct regulator_consumer_supply ab8500_vamic1_consumers[] = {
+	{  .dev = NULL, .supply = "vana-mic1", },
+};
+
+struct regulator_init_data ab8500_vamic1_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vamic1",
+		.min_uV = AB8500_VAMIC1_REGULATOR_MIN_VOLTAGE,
+		.max_uV = AB8500_VAMIC1_REGULATOR_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic1_consumers),
+	.consumer_supplies = ab8500_vamic1_consumers,
+};
+
+
+/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
+static struct regulator_consumer_supply ab8500_vamic2_consumers[] = {
+	{  .dev = NULL, .supply = "vana-mic2", },
+};
+
+struct regulator_init_data ab8500_vamic2_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vamic2",
+		.min_uV = AB8500_VAMIC1_REGULATOR_MIN_VOLTAGE,
+		.max_uV = AB8500_VAMIC1_REGULATOR_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
+	.consumer_supplies = ab8500_vamic2_consumers,
+};
+
+/* supply for v-dmic, VDMIC LDO */
+#define AB8500_VDMIC_REGULATOR_MIN_VOLTAGE      (1700000)
+#define AB8500_VDMIC_REGULATOR_MAX_VOLTAGE      (1950000)
+
+static struct regulator_consumer_supply ab8500_vdmic_consumers[] = {
+	{  .dev = NULL, .supply = "vdig-mic", },
+};
+
+struct regulator_init_data ab8500_vdmic_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vdmic",
+		.min_uV = AB8500_VDMIC_REGULATOR_MIN_VOLTAGE,
+		.max_uV = AB8500_VDMIC_REGULATOR_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vdmic_consumers),
+	.consumer_supplies = ab8500_vdmic_consumers,
+};
+
+/* supply for v-intcore12, VINTCORE12 LDO */
+#define AB8500_VINTCORE_REGULATOR_MIN_VOLTAGE      (1200000)
+#define AB8500_VINTCORE_REGULATOR_MAX_VOLTAGE      (1350000)
+
+static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
+	{ .dev = NULL, .supply = "vintcore", },
+};
+
+struct regulator_init_data ab8500_vintcore_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vintcore",
+		.min_uV = AB8500_VINTCORE_REGULATOR_MIN_VOLTAGE,
+		.max_uV = AB8500_VINTCORE_REGULATOR_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
+	.consumer_supplies = ab8500_vintcore_consumers,
+};
+
+/* supply for U8500 CSI/DSI, VANA LDO */
+#define AB8500_VANA_REGULATOR_MIN_VOLTAGE      (0)
+#define AB8500_VANA_REGULATOR_MAX_VOLTAGE      (1200000)
+
+static struct regulator_consumer_supply ab8500_vana_consumers[] = {
+	{ .dev = NULL, .supply = "vana", },
+};
+
+struct regulator_init_data ab8500_vana_init = {
+	.supply_regulator_dev = NULL,
+	.constraints = {
+		.name = "ab8500-vana",
+		.min_uV = AB8500_VANA_REGULATOR_MIN_VOLTAGE,
+		.max_uV = AB8500_VANA_REGULATOR_MAX_VOLTAGE,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
+					REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
+	.consumer_supplies = ab8500_vana_consumers,
+};
+
-- 
1.7.0

