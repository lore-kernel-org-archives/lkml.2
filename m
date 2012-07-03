Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab2GCDGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 23:06:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33316 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GCDGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:06:12 -0400
Message-ID: <1341284755.18757.5.camel@phoenix>
Subject: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking in
 tps65217_pmic_map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, "AnilKumar, Chimata" <anilkumar@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 03 Jul 2012 11:05:55 +0800
In-Reply-To: <1341284473.18757.2.camel@phoenix>
References: <1341284473.18757.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is ok to request voltage with min_uV < tps->info[rid]->min_uV and
max_uV > tps->info[rid]->max_uV

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 0a3df5b..0947a09 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -206,10 +206,7 @@ static int tps65217_pmic_map_voltage(struct regulator_dev *dev,
 	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
-		return -EINVAL;
-
-	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
+	if (max_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
 
 	ret = tps->info[rid]->uv_to_vsel(min_uV, &sel);
-- 
1.7.9.5



