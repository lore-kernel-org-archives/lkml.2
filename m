Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2LGJXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:23:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53822 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2LGJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:23:11 -0500
Message-ID: <1354872181.15243.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: lp8788-buck: Remove val array in
 lp8788_init_dvs
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 17:23:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All elements of val array are zero.
Simply set data argument to be 0 in lp8788_update_bits call and remove the val
array.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-buck.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 6cc02c3..d33b81a 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -478,7 +478,6 @@ static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
 {
 	struct lp8788_platform_data *pdata = buck->lp->pdata;
 	u8 mask[] = { LP8788_BUCK1_DVS_SEL_M, LP8788_BUCK2_DVS_SEL_M };
-	u8 val[]  = { LP8788_BUCK1_DVS_PIN, LP8788_BUCK2_DVS_PIN };
 	u8 default_dvs_mode[] = { LP8788_BUCK1_DVS_I2C, LP8788_BUCK2_DVS_I2C };
 
 	/* no dvs for buck3, 4 */
@@ -496,8 +495,7 @@ static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
 	if (lp8788_dvs_gpio_request(buck, id))
 		goto set_default_dvs_mode;
 
-	return lp8788_update_bits(buck->lp, LP8788_BUCK_DVS_SEL, mask[id],
-				val[id]);
+	return lp8788_update_bits(buck->lp, LP8788_BUCK_DVS_SEL, mask[id], 0);
 
 set_default_dvs_mode:
 	return lp8788_update_bits(buck->lp, LP8788_BUCK_DVS_SEL, mask[id],
-- 
1.7.9.5



