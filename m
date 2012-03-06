Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2CFXnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:43:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50514 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2CFXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:43:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.236.43.68 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1331077370.20711.2.camel@phoenix>
Subject: [PATCH RFC/RFT 1/2] regulator: Fix da9052 ldo regulator names
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 07 Mar 2012 07:42:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator name for LDOs are LDO4 ... LDO13 in current implementation.
The correct regulator name for LDOs should be LDO1 ... LDO10.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |   92 +++++++++++++++++++---------------
 1 files changed, 52 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 09915e8..ddcba36 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -37,6 +37,22 @@
 #define DA9052_BUCK_ILIM_MASK_EVEN	0x0c
 #define DA9052_BUCK_ILIM_MASK_ODD	0xc0
 
+/* DA9052 REGULATOR IDs */
+#define DA9052_ID_BUCK1		0
+#define DA9052_ID_BUCK2		1
+#define DA9052_ID_BUCK3		2
+#define DA9052_ID_BUCK4		3
+#define DA9052_ID_LDO1		4
+#define DA9052_ID_LDO2		5
+#define DA9052_ID_LDO3		6
+#define DA9052_ID_LDO4		7
+#define DA9052_ID_LDO5		8
+#define DA9052_ID_LDO6		9
+#define DA9052_ID_LDO7		10
+#define DA9052_ID_LDO8		11
+#define DA9052_ID_LDO9		12
+#define DA9052_ID_LDO10		13
+
 static const u32 da9052_current_limits[3][4] = {
 	{700000, 800000, 1000000, 1200000},	/* DA9052-BC BUCKs */
 	{1600000, 2000000, 2400000, 3000000},	/* DA9053-AA/Bx BUCK-CORE */
@@ -396,10 +412,10 @@ static struct regulator_ops da9052_ldo_ops = {
 #define DA9052_LDO5_6(_id, step, min, max, sbits, ebits, abits) \
 {\
 	.reg_desc = {\
-		.name = "LDO" #_id,\
+		.name = #_id,\
 		.ops = &da9052_ldo5_6_ops,\
 		.type = REGULATOR_VOLTAGE,\
-		.id = _id,\
+		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
@@ -414,10 +430,10 @@ static struct regulator_ops da9052_ldo_ops = {
 #define DA9052_LDO(_id, step, min, max, sbits, ebits, abits) \
 {\
 	.reg_desc = {\
-		.name = "LDO" #_id,\
+		.name = #_id,\
 		.ops = &da9052_ldo_ops,\
 		.type = REGULATOR_VOLTAGE,\
-		.id = _id,\
+		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
@@ -432,10 +448,10 @@ static struct regulator_ops da9052_ldo_ops = {
 #define DA9052_DCDC(_id, step, min, max, sbits, ebits, abits) \
 {\
 	.reg_desc = {\
-		.name = "BUCK" #_id,\
+		.name = #_id,\
 		.ops = &da9052_dcdc_ops,\
 		.type = REGULATOR_VOLTAGE,\
-		.id = _id,\
+		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
@@ -450,10 +466,10 @@ static struct regulator_ops da9052_ldo_ops = {
 #define DA9052_BUCKPERI(_id, step, min, max, sbits, ebits, abits) \
 {\
 	.reg_desc = {\
-		.name = "BUCK" #_id,\
+		.name = #_id,\
 		.ops = &da9052_buckperi_ops,\
 		.type = REGULATOR_VOLTAGE,\
-		.id = _id,\
+		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
@@ -466,41 +482,37 @@ static struct regulator_ops da9052_ldo_ops = {
 }
 
 static struct da9052_regulator_info da9052_regulator_info[] = {
-	/* Buck1 - 4 */
-	DA9052_DCDC(0, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
-	DA9052_DCDC(1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
-	DA9052_DCDC(2, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
-	DA9052_BUCKPERI(3, 50, 1800, 3600, 5, 6, 0),
-	/* LD01 - LDO10 */
-	DA9052_LDO(4, 50, 600, 1800, 5, 6, 0),
-	DA9052_LDO5_6(5, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
-	DA9052_LDO5_6(6, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
-	DA9052_LDO(7, 25, 1725, 3300, 6, 6, 0),
-	DA9052_LDO(8, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(9, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(10, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(11, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(12, 50, 1250, 3650, 6, 6, 0),
-	DA9052_LDO(13, 50, 1200, 3600, 6, 6, 0),
+	DA9052_DCDC(BUCK1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
+	DA9052_DCDC(BUCK2, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
+	DA9052_DCDC(BUCK3, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
+	DA9052_BUCKPERI(BUCK4, 50, 1800, 3600, 5, 6, 0),
+	DA9052_LDO(LDO1, 50, 600, 1800, 5, 6, 0),
+	DA9052_LDO5_6(LDO2, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
+	DA9052_LDO5_6(LDO3, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
+	DA9052_LDO(LDO4, 25, 1725, 3300, 6, 6, 0),
+	DA9052_LDO(LDO5, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO6, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO7, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO8, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO9, 50, 1250, 3650, 6, 6, 0),
+	DA9052_LDO(LDO10, 50, 1200, 3600, 6, 6, 0),
 };
 
 static struct da9052_regulator_info da9053_regulator_info[] = {
-	/* Buck1 - 4 */
-	DA9052_DCDC(0, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
-	DA9052_DCDC(1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
-	DA9052_DCDC(2, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
-	DA9052_BUCKPERI(3, 25, 925, 2500, 6, 6, 0),
-	/* LD01 - LDO10 */
-	DA9052_LDO(4, 50, 600, 1800, 5, 6, 0),
-	DA9052_LDO5_6(5, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
-	DA9052_LDO5_6(6, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
-	DA9052_LDO(7, 25, 1725, 3300, 6, 6, 0),
-	DA9052_LDO(8, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(9, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(10, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(11, 50, 1200, 3600, 6, 6, 0),
-	DA9052_LDO(12, 50, 1250, 3650, 6, 6, 0),
-	DA9052_LDO(13, 50, 1200, 3600, 6, 6, 0),
+	DA9052_DCDC(BUCK1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
+	DA9052_DCDC(BUCK2, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
+	DA9052_DCDC(BUCK3, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
+	DA9052_BUCKPERI(BUCK4, 25, 925, 2500, 6, 6, 0),
+	DA9052_LDO(LDO1, 50, 600, 1800, 5, 6, 0),
+	DA9052_LDO5_6(LDO2, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
+	DA9052_LDO5_6(LDO3, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
+	DA9052_LDO(LDO4, 25, 1725, 3300, 6, 6, 0),
+	DA9052_LDO(LDO5, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO6, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO7, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO8, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(LDO9, 50, 1250, 3650, 6, 6, 0),
+	DA9052_LDO(LDO10, 50, 1200, 3600, 6, 6, 0),
 };
 
 static inline struct da9052_regulator_info *find_regulator_info(u8 chip_id,
-- 
1.7.5.4



