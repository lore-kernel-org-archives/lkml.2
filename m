Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2GIPDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:03:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1994 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab2GIPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:03:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Jul 2012 08:03:12 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps65910: correct init value of n_voltages
Date: Mon, 9 Jul 2012 20:27:13 +0530
Message-ID: <1341845833-7023-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent change in the core driver to get the maximum voltage
is based on the (n_voltages -1) steps of voltage.
For the tps65910, the (n_voltages -1)th step voltage is
calculated based on the callback function list_voltage.
This function direct maps the datasheet and adjust the
first few steps for initial voltage as per datasheet,
and hence initialize the n_voltages based on datasheet.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch is created on top of
[PATCH V2] regulator: tps65910: add support for input supply
whcih is applied. But I am not able to see in regulator/for-next.
So assuming that it is applied and hence locally apply patch
before creating this patch.

 drivers/regulator/tps65910-regulator.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index e319d96..64c93e0 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -194,66 +194,66 @@ static struct tps_info tps65911_regs[] = {
 	{
 		.name = "vdd1",
 		.vin_name = "vcc1",
-		.n_voltages = 73,
+		.n_voltages = 0x4C,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd2",
 		.vin_name = "vcc2",
-		.n_voltages = 73,
+		.n_voltages = 0x4C,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vddctrl",
-		.n_voltages = 65,
+		.n_voltages = 0x44,
 		.enable_time_us = 900,
 	},
 	{
 		.name = "ldo1",
 		.vin_name = "vcc6",
-		.n_voltages = 47,
+		.n_voltages = 0x33,
 		.enable_time_us = 420,
 	},
 	{
 		.name = "ldo2",
 		.vin_name = "vcc6",
-		.n_voltages = 47,
+		.n_voltages = 0x33,
 		.enable_time_us = 420,
 	},
 	{
 		.name = "ldo3",
 		.vin_name = "vcc5",
-		.n_voltages = 24,
+		.n_voltages = 0x1A,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo4",
 		.vin_name = "vcc5",
-		.n_voltages = 47,
+		.n_voltages = 0x33,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo5",
 		.vin_name = "vcc4",
-		.n_voltages = 24,
+		.n_voltages = 0x1A,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo6",
 		.vin_name = "vcc3",
-		.n_voltages = 24,
+		.n_voltages = 0x1A,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo7",
 		.vin_name = "vcc3",
-		.n_voltages = 24,
+		.n_voltages = 0x1A,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo8",
 		.vin_name = "vcc3",
-		.n_voltages = 24,
+		.n_voltages = 0x1A,
 		.enable_time_us = 230,
 	},
 };
-- 
1.7.1.1

