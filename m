Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238Ab2FEAkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:40:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64471 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2FEAkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:40:03 -0400
Message-ID: <1338856792.4166.1.camel@phoenix>
Subject: [PATCH] regulator: tps6507x: Remove unused min_uV and max_uV from
 struct tps_info
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Anuj Aggarwal <anuj.aggarwal@ti.com>
Date: Tue, 05 Jun 2012 08:39:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min_uV and max_uV are not used in this driver.
For table based voltage mappings, we can get min_uV and max_uV by
info->table[0] and info->table[table_len -1].
Thus remove min_uV and max_uV from struct tps_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index c771e10..eed6678 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -91,8 +91,6 @@ static const unsigned int LDO2_VSEL_table[] = {
 
 struct tps_info {
 	const char *name;
-	unsigned min_uV;
-	unsigned max_uV;
 	u8 table_len;
 	const unsigned int *table;
 
@@ -103,36 +101,26 @@ struct tps_info {
 static struct tps_info tps6507x_pmic_regs[] = {
 	{
 		.name = "VDCDC1",
-		.min_uV = 725000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
 		.table = VDCDCx_VSEL_table,
 	},
 	{
 		.name = "VDCDC2",
-		.min_uV = 725000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
 		.table = VDCDCx_VSEL_table,
 	},
 	{
 		.name = "VDCDC3",
-		.min_uV = 725000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
 		.table = VDCDCx_VSEL_table,
 	},
 	{
 		.name = "LDO1",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(LDO1_VSEL_table),
 		.table = LDO1_VSEL_table,
 	},
 	{
 		.name = "LDO2",
-		.min_uV = 725000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(LDO2_VSEL_table),
 		.table = LDO2_VSEL_table,
 	},
-- 
1.7.9.5



