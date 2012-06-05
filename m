Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284Ab2FEA6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:58:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39530 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2FEA6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:58:19 -0400
Message-ID: <1338857893.4166.3.camel@phoenix>
Subject: [PATCH] regulator: tps6507x: Avoid duplicating the same mapping
 table for LDO2 and VDCDCx
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Anuj Aggarwal <anuj.aggarwal@ti.com>
Date: Tue, 05 Jun 2012 08:58:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage mapping table for LDO2 is exactly the same as VDCDCx.
Thus we can use one mapping table for both LDO2 and VDCDCx instead of
duplicating the mapping table.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index eed6678..07d01cc 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -70,24 +70,8 @@ static const unsigned int LDO1_VSEL_table[] = {
 	2800000, 3000000, 3100000, 3300000,
 };
 
-static const unsigned int LDO2_VSEL_table[] = {
-	725000, 750000, 775000, 800000,
-	825000, 850000, 875000, 900000,
-	925000, 950000, 975000, 1000000,
-	1025000, 1050000, 1075000, 1100000,
-	1125000, 1150000, 1175000, 1200000,
-	1225000, 1250000, 1275000, 1300000,
-	1325000, 1350000, 1375000, 1400000,
-	1425000, 1450000, 1475000, 1500000,
-	1550000, 1600000, 1650000, 1700000,
-	1750000, 1800000, 1850000, 1900000,
-	1950000, 2000000, 2050000, 2100000,
-	2150000, 2200000, 2250000, 2300000,
-	2350000, 2400000, 2450000, 2500000,
-	2550000, 2600000, 2650000, 2700000,
-	2750000, 2800000, 2850000, 2900000,
-	3000000, 3100000, 3200000, 3300000,
-};
+/* The voltage mapping table for LDO2 is the same as VDCDCx */
+#define LDO2_VSEL_table VDCDCx_VSEL_table
 
 struct tps_info {
 	const char *name;
-- 
1.7.9.5



