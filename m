Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1HBHeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:34:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1HBHeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:34:20 -0400
Subject: [PATCH] regulator: tps6507x: Remove num_voltages array
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 15:34:12 +0800
Message-ID: <1312270452.12639.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get n_voltages for each regulator from table_len of struct tps_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index bfffabc..bdef703 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -90,12 +90,6 @@ static const u16 LDO2_VSEL_table[] = {
 	3000, 3100, 3200, 3300,
 };
 
-static unsigned int num_voltages[] = {ARRAY_SIZE(VDCDCx_VSEL_table),
-				ARRAY_SIZE(VDCDCx_VSEL_table),
-				ARRAY_SIZE(VDCDCx_VSEL_table),
-				ARRAY_SIZE(LDO1_VSEL_table),
-				ARRAY_SIZE(LDO2_VSEL_table)};
-
 struct tps_info {
 	const char *name;
 	unsigned min_uV;
@@ -598,7 +592,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = i;
-		tps->desc[i].n_voltages = num_voltages[i];
+		tps->desc[i].n_voltages = info->table_len;
 		tps->desc[i].ops = (i > TPS6507X_DCDC_3 ?
 		&tps6507x_pmic_ldo_ops : &tps6507x_pmic_dcdc_ops);
 		tps->desc[i].type = REGULATOR_VOLTAGE;
-- 
1.7.4.1



