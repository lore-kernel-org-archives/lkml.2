Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2FUKp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:45:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34032 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2FUKpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:45:55 -0400
Message-ID: <1340275546.2922.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps65910: Remove unused min_uV and max_uV
 from struct tps_info
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 21 Jun 2012 18:45:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min_uV and max_uV fields of struct tps_info are not used in the code.
For the case voltage_table is provided, the min_uV and max_uV are the same
values as volt_table[0] and volt_table[n_voltages -1].
For the case voltage_table is not available, having the min_uV and max_uV seems
misleading. Current code uses equations to get the voltage value in this case,
but these equations do not use the min_uV and max_uV fields of struct tps_info.

Thus this patch removes the min_uV and max_uV fields from struct tps_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   50 --------------------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 373c529..edeaa2c 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -85,8 +85,6 @@ static const u16 VMMC_VSEL_table[] = {
 
 struct tps_info {
 	const char *name;
-	unsigned min_uV;
-	unsigned max_uV;
 	u8 n_voltages;
 	const u16 *voltage_table;
 	int enable_time_us;
@@ -99,92 +97,68 @@ static struct tps_info tps65910_regs[] = {
 	},
 	{
 		.name = "vio",
-		.min_uV = 1500000,
-		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
 		.voltage_table = VIO_VSEL_table,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd1",
-		.min_uV = 600000,
-		.max_uV = 4500000,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd2",
-		.min_uV = 600000,
-		.max_uV = 4500000,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd3",
-		.min_uV = 5000000,
-		.max_uV = 5000000,
 		.n_voltages = ARRAY_SIZE(VDD3_VSEL_table),
 		.voltage_table = VDD3_VSEL_table,
 		.enable_time_us = 200,
 	},
 	{
 		.name = "vdig1",
-		.min_uV = 1200000,
-		.max_uV = 2700000,
 		.n_voltages = ARRAY_SIZE(VDIG1_VSEL_table),
 		.voltage_table = VDIG1_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vdig2",
-		.min_uV = 1000000,
-		.max_uV = 1800000,
 		.n_voltages = ARRAY_SIZE(VDIG2_VSEL_table),
 		.voltage_table = VDIG2_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vpll",
-		.min_uV = 1000000,
-		.max_uV = 2500000,
 		.n_voltages = ARRAY_SIZE(VPLL_VSEL_table),
 		.voltage_table = VPLL_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vdac",
-		.min_uV = 1800000,
-		.max_uV = 2850000,
 		.n_voltages = ARRAY_SIZE(VDAC_VSEL_table),
 		.voltage_table = VDAC_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vaux1",
-		.min_uV = 1800000,
-		.max_uV = 2850000,
 		.n_voltages = ARRAY_SIZE(VAUX1_VSEL_table),
 		.voltage_table = VAUX1_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vaux2",
-		.min_uV = 1800000,
-		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VAUX2_VSEL_table),
 		.voltage_table = VAUX2_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vaux33",
-		.min_uV = 1800000,
-		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VAUX33_VSEL_table),
 		.voltage_table = VAUX33_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vmmc",
-		.min_uV = 1800000,
-		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VMMC_VSEL_table),
 		.voltage_table = VMMC_VSEL_table,
 		.enable_time_us = 100,
@@ -198,86 +172,62 @@ static struct tps_info tps65911_regs[] = {
 	},
 	{
 		.name = "vio",
-		.min_uV = 1500000,
-		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
 		.voltage_table = VIO_VSEL_table,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd1",
-		.min_uV = 600000,
-		.max_uV = 4500000,
 		.n_voltages = 73,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd2",
-		.min_uV = 600000,
-		.max_uV = 4500000,
 		.n_voltages = 73,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vddctrl",
-		.min_uV = 600000,
-		.max_uV = 1400000,
 		.n_voltages = 65,
 		.enable_time_us = 900,
 	},
 	{
 		.name = "ldo1",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 47,
 		.enable_time_us = 420,
 	},
 	{
 		.name = "ldo2",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 47,
 		.enable_time_us = 420,
 	},
 	{
 		.name = "ldo3",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo4",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 47,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo5",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo6",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo7",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo8",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
-- 
1.7.9.5



