Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2AMPUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:20:49 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:39710 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932522Ab2AMPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:44 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/8] mfd/db8500-prcmu: spawned regulators update
Date: Fri, 13 Jan 2012 16:20:36 +0100
Message-ID: <1326468036-11828-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

As drivers have progressed and got some more review we have
consequently moved things around:

- Some device drivers have changed name and some were wrong
  from the beginning.
- We removed the dependency from some domains to the VAPE
  domain -  SIA MMDSP, SIA PIPE, SVA MMDSP and SVA PIPE power
  domains are handled outside the framework while ESRAM12
  and ESRAM34 are actually handled inside the PRCMU.

Reviewed-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 9459327..1385639 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2687,19 +2687,17 @@ static struct regulator_consumer_supply db8500_vape_consumers[] = {
 	REGULATOR_SUPPLY("vcore", "uart1"),
 	REGULATOR_SUPPLY("vcore", "uart2"),
 	REGULATOR_SUPPLY("v-ape", "nmk-ske-keypad.0"),
+	REGULATOR_SUPPLY("v-hsi", "ste_hsi.0"),
 };
 
 static struct regulator_consumer_supply db8500_vsmps2_consumers[] = {
-	/* CG2900 and CW1200 power to off-chip peripherals */
-	REGULATOR_SUPPLY("gbf_1v8", "cg2900-uart.0"),
-	REGULATOR_SUPPLY("wlan_1v8", "cw1200.0"),
 	REGULATOR_SUPPLY("musb_1v8", "ab8500-usb.0"),
 	/* AV8100 regulator */
 	REGULATOR_SUPPLY("hdmi_1v8", "0-0070"),
 };
 
 static struct regulator_consumer_supply db8500_b2r2_mcde_consumers[] = {
-	REGULATOR_SUPPLY("vsupply", "b2r2.0"),
+	REGULATOR_SUPPLY("vsupply", "b2r2_bus"),
 	REGULATOR_SUPPLY("vsupply", "mcde"),
 };
 
@@ -2736,6 +2734,7 @@ static struct regulator_consumer_supply db8500_esram12_consumers[] = {
 static struct regulator_consumer_supply db8500_esram34_consumers[] = {
 	REGULATOR_SUPPLY("v-esram34", "mcde"),
 	REGULATOR_SUPPLY("esram34", "cm_control"),
+	REGULATOR_SUPPLY("lcla_esram", "dma40.0"),
 };
 
 static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
@@ -2792,7 +2791,7 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 		},
 	},
 	[DB8500_REGULATOR_SWITCH_SVAMMDSP] = {
-		.supply_regulator = "db8500-vape",
+		/* dependency to u8500-vape is handled outside regulator framework */
 		.constraints = {
 			.name = "db8500-sva-mmdsp",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
@@ -2808,7 +2807,7 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 		},
 	},
 	[DB8500_REGULATOR_SWITCH_SVAPIPE] = {
-		.supply_regulator = "db8500-vape",
+		/* dependency to u8500-vape is handled outside regulator framework */
 		.constraints = {
 			.name = "db8500-sva-pipe",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
@@ -2817,7 +2816,7 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 		.num_consumer_supplies = ARRAY_SIZE(db8500_svapipe_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_SIAMMDSP] = {
-		.supply_regulator = "db8500-vape",
+		/* dependency to u8500-vape is handled outside regulator framework */
 		.constraints = {
 			.name = "db8500-sia-mmdsp",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
@@ -2832,7 +2831,7 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 		},
 	},
 	[DB8500_REGULATOR_SWITCH_SIAPIPE] = {
-		.supply_regulator = "db8500-vape",
+		/* dependency to u8500-vape is handled outside regulator framework */
 		.constraints = {
 			.name = "db8500-sia-pipe",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
@@ -2860,7 +2859,10 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 		.num_consumer_supplies = ARRAY_SIZE(db8500_b2r2_mcde_consumers),
 	},
 	[DB8500_REGULATOR_SWITCH_ESRAM12] = {
-		.supply_regulator = "db8500-vape",
+		/*
+		 * esram12 is set in retention and supplied by Vsafe when Vape is off,
+		 * no need to hold Vape
+		 */
 		.constraints = {
 			.name = "db8500-esram12",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
@@ -2875,7 +2877,10 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 		},
 	},
 	[DB8500_REGULATOR_SWITCH_ESRAM34] = {
-		.supply_regulator = "db8500-vape",
+		/*
+		 * esram34 is set in retention and supplied by Vsafe when Vape is off,
+		 * no need to hold Vape
+		 */
 		.constraints = {
 			.name = "db8500-esram34",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-- 
1.7.8

