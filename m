Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2H1LvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:51:09 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36813 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2H1LsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:17 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 5/6] mfd: change regulator defns to better suite DT
Date: Tue, 28 Aug 2012 13:47:39 +0200
Message-Id: <1346154460-20031-6-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to better fit DT parsing in of regulator definitions re-arrange
the platform data struct slightly which requires the definitions of
the regulator IDs earlier in the include file.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 include/linux/mfd/palmas.h |   60 ++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index cfbf794..29f6616 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -130,16 +130,44 @@ struct palmas_reg_init {
 
 };
 
+enum palmas_regulators {
+	/* SMPS regulators */
+	PALMAS_REG_SMPS12,
+	PALMAS_REG_SMPS123,
+	PALMAS_REG_SMPS3,
+	PALMAS_REG_SMPS45,
+	PALMAS_REG_SMPS457,
+	PALMAS_REG_SMPS6,
+	PALMAS_REG_SMPS7,
+	PALMAS_REG_SMPS8,
+	PALMAS_REG_SMPS9,
+	PALMAS_REG_SMPS10,
+	/* LDO regulators */
+	PALMAS_REG_LDO1,
+	PALMAS_REG_LDO2,
+	PALMAS_REG_LDO3,
+	PALMAS_REG_LDO4,
+	PALMAS_REG_LDO5,
+	PALMAS_REG_LDO6,
+	PALMAS_REG_LDO7,
+	PALMAS_REG_LDO8,
+	PALMAS_REG_LDO9,
+	PALMAS_REG_LDOLN,
+	PALMAS_REG_LDOUSB,
+	/* Total number of regulators */
+	PALMAS_NUM_REGS,
+};
+
 struct palmas_pmic_platform_data {
 	/* An array of pointers to regulator init data indexed by regulator
 	 * ID
 	 */
-	struct regulator_init_data **reg_data;
+	struct regulator_init_data *reg_data[PALMAS_NUM_REGS];
 
 	/* An array of pointers to structures containing sleep mode and DVS
 	 * configuration for regulators indexed by ID
 	 */
-	struct palmas_reg_init **reg_init;
+	struct palmas_reg_init *reg_init[PALMAS_NUM_REGS];
 
 	/* use LDO6 for vibrator control */
 	int ldo6_vibrator;
@@ -291,34 +319,6 @@ enum palmas_irqs {
 	PALMAS_NUM_IRQ,
 };
 
-enum palmas_regulators {
-	/* SMPS regulators */
-	PALMAS_REG_SMPS12,
-	PALMAS_REG_SMPS123,
-	PALMAS_REG_SMPS3,
-	PALMAS_REG_SMPS45,
-	PALMAS_REG_SMPS457,
-	PALMAS_REG_SMPS6,
-	PALMAS_REG_SMPS7,
-	PALMAS_REG_SMPS8,
-	PALMAS_REG_SMPS9,
-	PALMAS_REG_SMPS10,
-	/* LDO regulators */
-	PALMAS_REG_LDO1,
-	PALMAS_REG_LDO2,
-	PALMAS_REG_LDO3,
-	PALMAS_REG_LDO4,
-	PALMAS_REG_LDO5,
-	PALMAS_REG_LDO6,
-	PALMAS_REG_LDO7,
-	PALMAS_REG_LDO8,
-	PALMAS_REG_LDO9,
-	PALMAS_REG_LDOLN,
-	PALMAS_REG_LDOUSB,
-	/* Total number of regulators */
-	PALMAS_NUM_REGS,
-};
-
 struct palmas_pmic {
 	struct palmas *palmas;
 	struct device *dev;
-- 
1.7.9.5

