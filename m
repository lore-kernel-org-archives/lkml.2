Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2DJGWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:22:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34176 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2DJGWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:22:44 -0400
Message-ID: <1334038958.15859.17.camel@phoenix>
Subject: [PATCH 3/3] regulator: max8997: Remove n_bits from struct
 voltage_map_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 14:22:38 +0800
In-Reply-To: <1334038803.15859.14.camel@phoenix>
References: <1334038803.15859.14.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The n_bits is only used in max8997_get_voltage_proper_val to check the valid
range for variable i.

Current code already ensures min_vol never greater than desc->max,
which means the variable i always in the valid range:
0 .. (desc->max - desc->min)/desc->step.

Thus we can remove the checking (i >= (1 << desc->n_bits) and then remove
n_bits from struct voltage_map_desc.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index e0fa9b7..e490141 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -68,29 +68,28 @@ struct voltage_map_desc {
 	int min;
 	int max;
 	int step;
-	unsigned int n_bits;
 };
 
 /* Voltage maps in mV */
 static const struct voltage_map_desc ldo_voltage_map_desc = {
-	.min = 800,	.max = 3950,	.step = 50,	.n_bits = 6,
+	.min = 800,	.max = 3950,	.step = 50,
 }; /* LDO1 ~ 18, 21 all */
 
 static const struct voltage_map_desc buck1245_voltage_map_desc = {
-	.min = 650,	.max = 2225,	.step = 25,	.n_bits = 6,
+	.min = 650,	.max = 2225,	.step = 25,
 }; /* Buck1, 2, 4, 5 */
 
 static const struct voltage_map_desc buck37_voltage_map_desc = {
-	.min = 750,	.max = 3900,	.step = 50,	.n_bits = 6,
+	.min = 750,	.max = 3900,	.step = 50,
 }; /* Buck3, 7 */
 
 /* current map in mA */
 static const struct voltage_map_desc charger_current_map_desc = {
-	.min = 200,	.max = 950,	.step = 50,	.n_bits = 4,
+	.min = 200,	.max = 950,	.step = 50,
 };
 
 static const struct voltage_map_desc topoff_current_map_desc = {
-	.min = 50,	.max = 200,	.step = 10,	.n_bits = 4,
+	.min = 50,	.max = 200,	.step = 10,
 };
 
 static const struct voltage_map_desc *reg_voltage_map[] = {
@@ -432,9 +431,6 @@ static inline int max8997_get_voltage_proper_val(
 	if (desc->min + desc->step * i > max_vol)
 		return -EINVAL;
 
-	if (i >= (1 << desc->n_bits))
-		return -EINVAL;
-
 	return i;
 }
 
-- 
1.7.5.4



