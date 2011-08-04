Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1HDLeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:34:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45926 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1HDLeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:34:18 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 4/4] regulator: tps65023: Added support for the similiar TPS65020 chip
Date: Thu,  4 Aug 2011 13:33:52 +0200
Message-Id: <1312457632-27075-5-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines a new voltage-table and allows registering of the tps65020 device.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   53 ++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 0161410..bf3f91c 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -103,7 +103,16 @@ static const u16 VCORE_VSEL_table[] = {
 	1500, 1525, 1550, 1600,
 };
 
+/* Supported voltage values for LDO regulators for tps65020 */
+static const u16 TPS65020_LDO1_VSEL_table[] = {
+	1000, 1050, 1100, 1300,
+	1800, 2500, 3000, 3300,
+};
 
+static const u16 TPS65020_LDO2_VSEL_table[] = {
+	1000, 1050, 1100, 1300,
+	1800, 2500, 3000, 3300,
+};
 
 /* Supported voltage values for LDO regulators
  * for tps65021 and tps65023 */
@@ -535,6 +544,43 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct tps_info tps65020_regs[] = {
+	{
+		.name = "VDCDC1",
+		.min_uV = 3300000,
+		.max_uV = 3300000,
+		.fixed	= 1,
+	},
+	{
+		.name = "VDCDC2",
+		.min_uV =  1800000,
+		.max_uV = 1800000,
+		.fixed = 1,
+	},
+	{
+		.name = "VDCDC3",
+		.min_uV =  800000,
+		.max_uV = 1600000,
+		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
+		.table = VCORE_VSEL_table,
+	},
+
+	{
+		.name = "LDO1",
+		.min_uV = 1000000,
+		.max_uV = 3150000,
+		.table_len = ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
+		.table = TPS65020_LDO1_VSEL_table,
+	},
+	{
+		.name = "LDO2",
+		.min_uV = 1050000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(TPS65020_LDO2_VSEL_table),
+		.table = TPS65020_LDO2_VSEL_table,
+	},
+};
+
 static const struct tps_info tps65021_regs[] = {
 	{
 		.name = "VDCDC1",
@@ -607,6 +653,11 @@ static const struct tps_info tps65023_regs[] = {
 	},
 };
 
+static struct tps_driver_data tps65020_drv_data = {
+		.info = tps65020_regs,
+		.core_regulator = TPS65023_DCDC_3,
+};
+
 static struct tps_driver_data tps65021_drv_data = {
 		.info = tps65021_regs,
 		.core_regulator = TPS65023_DCDC_3,
@@ -622,6 +673,8 @@ static const struct i2c_device_id tps_65023_id[] = {
 	.driver_data = (unsigned long) &tps65023_drv_data},
 	{.name = "tps65021",
 	.driver_data = (unsigned long) &tps65021_drv_data,},
+	{.name = "tps65020",
+	.driver_data = (unsigned long) &tps65020_drv_data},
 	{ },
 };
 
-- 
1.7.4.1

