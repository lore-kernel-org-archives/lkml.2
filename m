Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0LJKKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:10:51 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:47622 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab0LJKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:10:49 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 9/9] mach-ux500: Updated and connected ab8500 regulator board configuration
Date: Fri, 10 Dec 2010 11:08:48 +0100
Message-ID: <1291975728-12525-10-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ab8500 regulator board configuration is updated and put in an
array which can easily be used in the MFD board configuration. The
regulator board configuration is also added to the MFD
configuration in this patch.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  153 ++++++++++++-------------
 arch/arm/mach-ux500/board-mop500-regulators.h |   19 +++
 arch/arm/mach-ux500/board-mop500.c            |    3 +
 3 files changed, 96 insertions(+), 79 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-regulators.h

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 1187f1f..533967c 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -3,99 +3,94 @@
  *
  * License Terms: GNU General Public License v2
  *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com>
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com>
  *
  * MOP500 board specific initialization for regulators
  */
 #include <linux/kernel.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/ab8500.h>
 
-/* supplies to the display/camera */
-static struct regulator_init_data ab8500_vaux1_regulator = {
-	.constraints = {
-		.name = "V-DISPLAY",
-		.min_uV = 2500000,
-		.max_uV = 2900000,
-		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
-					REGULATOR_CHANGE_STATUS,
+/* AB8500 regulators */
+struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
+	/* supplies to the display/camera */
+	[AB8500_LDO_AUX1] = {
+		.constraints = {
+			.name = "V-DISPLAY",
+			.min_uV = 2500000,
+			.max_uV = 2900000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supplies to the on-board eMMC */
-static struct regulator_init_data ab8500_vaux2_regulator = {
-	.constraints = {
-		.name = "V-eMMC1",
-		.min_uV = 1100000,
-		.max_uV = 3300000,
-		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
-					REGULATOR_CHANGE_STATUS,
+	/* supplies to the on-board eMMC */
+	[AB8500_LDO_AUX2] = {
+		.constraints = {
+			.name = "V-eMMC1",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for VAUX3, supplies to SDcard slots */
-static struct regulator_init_data ab8500_vaux3_regulator = {
-	.constraints = {
-		.name = "V-MMC-SD",
-		.min_uV = 1100000,
-		.max_uV = 3300000,
-		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
-					REGULATOR_CHANGE_STATUS,
+	/* supply for VAUX3, supplies to SDcard slots */
+	[AB8500_LDO_AUX3] = {
+		.constraints = {
+			.name = "V-MMC-SD",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for tvout, gpadc, TVOUT LDO */
-static struct regulator_init_data ab8500_vtvout_init = {
-	.constraints = {
-		.name = "V-TVOUT",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for tvout, gpadc, TVOUT LDO */
+	[AB8500_LDO_TVOUT] = {
+		.constraints = {
+			.name = "V-TVOUT",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for ab8500-vaudio, VAUDIO LDO */
-static struct regulator_init_data ab8500_vaudio_init = {
-	.constraints = {
-		.name = "V-AUD",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for ab8500-vaudio, VAUDIO LDO */
+	[AB8500_LDO_AUDIO] = {
+		.constraints = {
+			.name = "V-AUD",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for v-anamic1 VAMic1-LDO */
-static struct regulator_init_data ab8500_vamic1_init = {
-	.constraints = {
-		.name = "V-AMIC1",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for v-anamic1 VAMic1-LDO */
+	[AB8500_LDO_ANAMIC1] = {
+		.constraints = {
+			.name = "V-AMIC1",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
-static struct regulator_init_data ab8500_vamic2_init = {
-	.constraints = {
-		.name = "V-AMIC2",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
+	[AB8500_LDO_ANAMIC2] = {
+		.constraints = {
+			.name = "V-AMIC2",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for v-dmic, VDMIC LDO */
-static struct regulator_init_data ab8500_vdmic_init = {
-	.constraints = {
-		.name = "V-DMIC",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for v-dmic, VDMIC LDO */
+	[AB8500_LDO_DMIC] = {
+		.constraints = {
+			.name = "V-DMIC",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for v-intcore12, VINTCORE12 LDO */
-static struct regulator_init_data ab8500_vintcore_init = {
-	.constraints = {
-		.name = "V-INTCORE",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for v-intcore12, VINTCORE12 LDO */
+	[AB8500_LDO_INTCORE] = {
+		.constraints = {
+			.name = "V-INTCORE",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
-};
-
-/* supply for U8500 CSI/DSI, VANA LDO */
-static struct regulator_init_data ab8500_vana_init = {
-	.constraints = {
-		.name = "V-CSI/DSI",
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	/* supply for U8500 CSI/DSI, VANA LDO */
+	[AB8500_LDO_ANA] = {
+		.constraints = {
+			.name = "V-CSI/DSI",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
 	},
 };
-
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
new file mode 100644
index 0000000..2675fae
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * MOP500 board specific initialization for regulators
+ */
+
+#ifndef __BOARD_MOP500_REGULATORS_H
+#define __BOARD_MOP500_REGULATORS_H
+
+#include <linux/regulator/machine.h>
+#include <linux/regulator/ab8500.h>
+
+extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
+
+#endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index cac83a6..41285ad 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -34,6 +34,7 @@
 
 #include "pins-db8500.h"
 #include "board-mop500.h"
+#include "board-mop500-regulators.h"
 
 static pin_cfg_t mop500_pins[] = {
 	/* SSP0 */
@@ -89,6 +90,8 @@ struct pl022_config_chip ab4500_chip_info = {
 
 static struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
+	.regulator	= ab8500_regulators,
+	.num_regulator	= ARRAY_SIZE(ab8500_regulators),
 };
 
 static struct resource ab8500_resources[] = {
-- 
1.7.2.2

