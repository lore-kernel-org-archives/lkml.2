Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1HLI3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:29:21 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:57123 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:29:18 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 11/23] mfd/db8500-prcmu: voltage domain consumers
Date: Fri, 12 Aug 2011 10:29:02 +0200
Message-ID: <1313137742-30948-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

This rectifies the device name of the MCDE voltage domain
regulator consumer and adds a number of other consumers to
the voltage domains.

Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   52 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 6fd4e29..91a5e8c 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2199,7 +2199,42 @@ static struct regulator_consumer_supply db8500_vsmps2_consumers[] = {
 
 static struct regulator_consumer_supply db8500_b2r2_mcde_consumers[] = {
 	REGULATOR_SUPPLY("vsupply", "b2r2.0"),
-	REGULATOR_SUPPLY("vsupply", "mcde.0"),
+	REGULATOR_SUPPLY("vsupply", "mcde"),
+};
+
+/* SVA MMDSP regulator switch */
+static struct regulator_consumer_supply db8500_svammdsp_consumers[] = {
+	REGULATOR_SUPPLY("sva-mmdsp", "cm_control"),
+};
+
+/* SVA pipe regulator switch */
+static struct regulator_consumer_supply db8500_svapipe_consumers[] = {
+	REGULATOR_SUPPLY("sva-pipe", "cm_control"),
+};
+
+/* SIA MMDSP regulator switch */
+static struct regulator_consumer_supply db8500_siammdsp_consumers[] = {
+	REGULATOR_SUPPLY("sia-mmdsp", "cm_control"),
+};
+
+/* SIA pipe regulator switch */
+static struct regulator_consumer_supply db8500_siapipe_consumers[] = {
+	REGULATOR_SUPPLY("sia-pipe", "cm_control"),
+};
+
+static struct regulator_consumer_supply db8500_sga_consumers[] = {
+	REGULATOR_SUPPLY("v-mali", NULL),
+};
+
+/* ESRAM1 and 2 regulator switch */
+static struct regulator_consumer_supply db8500_esram12_consumers[] = {
+	REGULATOR_SUPPLY("esram12", "cm_control"),
+};
+
+/* ESRAM3 and 4 regulator switch */
+static struct regulator_consumer_supply db8500_esram34_consumers[] = {
+	REGULATOR_SUPPLY("v-esram34", "mcde"),
+	REGULATOR_SUPPLY("esram34", "cm_control"),
 };
 
 static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
@@ -2261,6 +2296,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-sva-mmdsp",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_svammdsp_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_svammdsp_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_SVAMMDSPRET] = {
 		.constraints = {
@@ -2275,6 +2312,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-sva-pipe",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_svapipe_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_svapipe_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_SIAMMDSP] = {
 		.supply_regulator = "db8500-vape",
@@ -2282,6 +2321,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-sia-mmdsp",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_siammdsp_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_siammdsp_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_SIAMMDSPRET] = {
 		.constraints = {
@@ -2295,6 +2336,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-sia-pipe",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_siapipe_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_siapipe_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_SGA] = {
 		.supply_regulator = "db8500-vape",
@@ -2302,6 +2345,9 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-sga",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_sga_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_sga_consumers),
+
 	},
 	[DB8500_REGULATOR_SWITCH_B2R2_MCDE] = {
 		.supply_regulator = "db8500-vape",
@@ -2318,6 +2364,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-esram12",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_esram12_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_esram12_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_ESRAM12RET] = {
 		.constraints = {
@@ -2331,6 +2379,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 			.name = "db8500-esram34",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
+		.consumer_supplies = db8500_esram34_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_esram34_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_ESRAM34RET] = {
 		.constraints = {
-- 
1.7.3.2

