Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1GJCCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 22:02:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38524 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1GJCCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 22:02:30 -0400
From: Ambresh K <ambresh@ti.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: TWL: Remove entry of RES_ID for 6030 macros
Date: Sat, 9 Jul 2011 19:02:21 -0700
Message-ID: <1310263341-29620-1-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

RES_ID is only used in 4030, to send PBM singular message to control
the state of dedicated resources. In 6030, we don't have concept of PBM,
hence removing the definition of RES_ID (num) from macros.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 drivers/regulator/twl-regulator.c |   64 +++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 87fe0f7..a4c5e46 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -835,8 +835,8 @@ static struct regulator_ops twlsmps_ops = {
 			remap_conf) \
 		TWL_FIXED_LDO(label, offset, mVolts, num, turnon_delay, \
 			remap_conf, TWL4030, twl4030fixed_ops)
-#define TWL6030_FIXED_LDO(label, offset, mVolts, num, turnon_delay) \
-		TWL_FIXED_LDO(label, offset, mVolts, num, turnon_delay, \
+#define TWL6030_FIXED_LDO(label, offset, mVolts, turnon_delay) \
+		TWL_FIXED_LDO(label, offset, mVolts, 0x0, turnon_delay, \
 			0x0, TWL6030, twl6030fixed_ops)
 
 #define TWL4030_ADJUSTABLE_LDO(label, offset, num, turnon_delay, remap_conf) { \
@@ -856,9 +856,8 @@ static struct regulator_ops twlsmps_ops = {
 		}, \
 	}
 
-#define TWL6030_ADJUSTABLE_LDO(label, offset, min_mVolts, max_mVolts, num) { \
+#define TWL6030_ADJUSTABLE_LDO(label, offset, min_mVolts, max_mVolts) { \
 	.base = offset, \
-	.id = num, \
 	.min_mV = min_mVolts, \
 	.max_mV = max_mVolts, \
 	.desc = { \
@@ -871,9 +870,8 @@ static struct regulator_ops twlsmps_ops = {
 		}, \
 	}
 
-#define TWL6025_ADJUSTABLE_LDO(label, offset, min_mVolts, max_mVolts, num) { \
+#define TWL6025_ADJUSTABLE_LDO(label, offset, min_mVolts, max_mVolts) { \
 	.base = offset, \
-	.id = num, \
 	.min_mV = min_mVolts, \
 	.max_mV = max_mVolts, \
 	.desc = { \
@@ -903,9 +901,8 @@ static struct regulator_ops twlsmps_ops = {
 		}, \
 	}
 
-#define TWL6030_FIXED_RESOURCE(label, offset, num, turnon_delay) { \
+#define TWL6030_FIXED_RESOURCE(label, offset, turnon_delay) { \
 	.base = offset, \
-	.id = num, \
 	.delay = turnon_delay, \
 	.desc = { \
 		.name = #label, \
@@ -916,9 +913,8 @@ static struct regulator_ops twlsmps_ops = {
 		}, \
 	}
 
-#define TWL6025_ADJUSTABLE_SMPS(label, offset, num) { \
+#define TWL6025_ADJUSTABLE_SMPS(label, offset) { \
 	.base = offset, \
-	.id = num, \
 	.min_mV = 600, \
 	.max_mV = 2100, \
 	.desc = { \
@@ -961,32 +957,32 @@ static struct twlreg_info twl_regs[] = {
 	/* 6030 REG with base as PMC Slave Misc : 0x0030 */
 	/* Turnon-delay and remap configuration values for 6030 are not
 	   verified since the specification is not public */
-	TWL6030_ADJUSTABLE_LDO(VAUX1_6030, 0x54, 1000, 3300, 1),
-	TWL6030_ADJUSTABLE_LDO(VAUX2_6030, 0x58, 1000, 3300, 2),
-	TWL6030_ADJUSTABLE_LDO(VAUX3_6030, 0x5c, 1000, 3300, 3),
-	TWL6030_ADJUSTABLE_LDO(VMMC, 0x68, 1000, 3300, 4),
-	TWL6030_ADJUSTABLE_LDO(VPP, 0x6c, 1000, 3300, 5),
-	TWL6030_ADJUSTABLE_LDO(VUSIM, 0x74, 1000, 3300, 7),
-	TWL6030_FIXED_LDO(VANA, 0x50, 2100, 15, 0),
-	TWL6030_FIXED_LDO(VCXIO, 0x60, 1800, 16, 0),
-	TWL6030_FIXED_LDO(VDAC, 0x64, 1800, 17, 0),
-	TWL6030_FIXED_LDO(VUSB, 0x70, 3300, 18, 0),
-	TWL6030_FIXED_RESOURCE(CLK32KG, 0x8C, 48, 0),
+	TWL6030_ADJUSTABLE_LDO(VAUX1_6030, 0x54, 1000, 3300),
+	TWL6030_ADJUSTABLE_LDO(VAUX2_6030, 0x58, 1000, 3300),
+	TWL6030_ADJUSTABLE_LDO(VAUX3_6030, 0x5c, 1000, 3300),
+	TWL6030_ADJUSTABLE_LDO(VMMC, 0x68, 1000, 3300),
+	TWL6030_ADJUSTABLE_LDO(VPP, 0x6c, 1000, 3300),
+	TWL6030_ADJUSTABLE_LDO(VUSIM, 0x74, 1000, 3300),
+	TWL6030_FIXED_LDO(VANA, 0x50, 2100, 0),
+	TWL6030_FIXED_LDO(VCXIO, 0x60, 1800, 0),
+	TWL6030_FIXED_LDO(VDAC, 0x64, 1800, 0),
+	TWL6030_FIXED_LDO(VUSB, 0x70, 3300, 0),
+	TWL6030_FIXED_RESOURCE(CLK32KG, 0x8C, 0),
 
 	/* 6025 are renamed compared to 6030 versions */
-	TWL6025_ADJUSTABLE_LDO(LDO2, 0x54, 1000, 3300, 1),
-	TWL6025_ADJUSTABLE_LDO(LDO4, 0x58, 1000, 3300, 2),
-	TWL6025_ADJUSTABLE_LDO(LDO3, 0x5c, 1000, 3300, 3),
-	TWL6025_ADJUSTABLE_LDO(LDO5, 0x68, 1000, 3300, 4),
-	TWL6025_ADJUSTABLE_LDO(LDO1, 0x6c, 1000, 3300, 5),
-	TWL6025_ADJUSTABLE_LDO(LDO7, 0x74, 1000, 3300, 7),
-	TWL6025_ADJUSTABLE_LDO(LDO6, 0x60, 1000, 3300, 16),
-	TWL6025_ADJUSTABLE_LDO(LDOLN, 0x64, 1000, 3300, 17),
-	TWL6025_ADJUSTABLE_LDO(LDOUSB, 0x70, 1000, 3300, 18),
-
-	TWL6025_ADJUSTABLE_SMPS(SMPS3, 0x34, 1),
-	TWL6025_ADJUSTABLE_SMPS(SMPS4, 0x10, 2),
-	TWL6025_ADJUSTABLE_SMPS(VIO, 0x16, 3),
+	TWL6025_ADJUSTABLE_LDO(LDO2, 0x54, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDO4, 0x58, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDO3, 0x5c, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDO5, 0x68, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDO1, 0x6c, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDO7, 0x74, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDO6, 0x60, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDOLN, 0x64, 1000, 3300),
+	TWL6025_ADJUSTABLE_LDO(LDOUSB, 0x70, 1000, 3300),
+
+	TWL6025_ADJUSTABLE_SMPS(SMPS3, 0x34),
+	TWL6025_ADJUSTABLE_SMPS(SMPS4, 0x10),
+	TWL6025_ADJUSTABLE_SMPS(VIO, 0x16),
 };
 
 static u8 twl_get_smps_offset(void)
-- 
1.7.0.4

