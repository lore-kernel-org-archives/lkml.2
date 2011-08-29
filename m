Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1H2OyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:54:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52619 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1H2OyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:54:16 -0400
Subject: [PATCH v2 RESEND] regulator: tps65023: Remove num_voltages array
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 22:54:09 +0800
Message-ID: <1314629649.2753.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get n_voltages for each regulator from table_len of struct tps_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/tps65023-regulator.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 701a590..3d2a81a 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -106,10 +106,6 @@ static const u16 LDO2_VSEL_table[] = {
 	2500, 2800, 3000, 3300,
 };
 
-static unsigned int num_voltages[] = {ARRAY_SIZE(VDCDC1_VSEL_table),
-				0, 0, ARRAY_SIZE(LDO1_VSEL_table),
-				ARRAY_SIZE(LDO2_VSEL_table)};
-
 /* Regulator specific details */
 struct tps_info {
 	const char *name;
@@ -453,7 +449,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = i;
-		tps->desc[i].n_voltages = num_voltages[i];
+		tps->desc[i].n_voltages = info->table_len;
 		tps->desc[i].ops = (i > TPS65023_DCDC_3 ?
 					&tps65023_ldo_ops : &tps65023_dcdc_ops);
 		tps->desc[i].type = REGULATOR_VOLTAGE;
-- 
1.7.4.1



