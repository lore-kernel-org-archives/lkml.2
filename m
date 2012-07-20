Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2GTOWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:22:34 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34042 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2GTOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:22:31 -0400
Message-ID: <1342794140.3401.1.camel@phoenix>
Subject: [PATCH] regulator: lp8788-buck: Remove
 lp8788_set_default_dvs_ctrl_mode function
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jul 2012 22:22:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already know the mask in lp8788_init_dvs() function, and we can update
the corresponding bit for default_dvs_mode in lp8788_init_dvs() function.
This function looks not necessary to me.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp8788-buck.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 6356e82..0c93a6a 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -459,27 +459,6 @@ static struct regulator_desc lp8788_buck_desc[] = {
 	},
 };
 
-static int lp8788_set_default_dvs_ctrl_mode(struct lp8788 *lp,
-					enum lp8788_buck_id id)
-{
-	u8 mask, val;
-
-	switch (id) {
-	case BUCK1:
-		mask = LP8788_BUCK1_DVS_SEL_M;
-		val  = LP8788_BUCK1_DVS_I2C;
-		break;
-	case BUCK2:
-		mask = LP8788_BUCK2_DVS_SEL_M;
-		val  = LP8788_BUCK2_DVS_I2C;
-		break;
-	default:
-		return 0;
-	}
-
-	return lp8788_update_bits(lp, LP8788_BUCK_DVS_SEL, mask, val);
-}
-
 static int _gpio_request(struct lp8788_buck *buck, int gpio, char *name)
 {
 	struct device *dev = buck->lp->dev;
@@ -530,6 +509,7 @@ static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
 	struct lp8788_platform_data *pdata = buck->lp->pdata;
 	u8 mask[] = { LP8788_BUCK1_DVS_SEL_M, LP8788_BUCK2_DVS_SEL_M };
 	u8 val[]  = { LP8788_BUCK1_DVS_PIN, LP8788_BUCK2_DVS_PIN };
+	u8 default_dvs_mode[] = { LP8788_BUCK1_DVS_I2C, LP8788_BUCK2_DVS_I2C };
 
 	/* no dvs for buck3, 4 */
 	if (id == BUCK3 || id == BUCK4)
@@ -550,7 +530,8 @@ static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
 				val[id]);
 
 set_default_dvs_mode:
-	return lp8788_set_default_dvs_ctrl_mode(buck->lp, id);
+	return lp8788_update_bits(buck->lp, LP8788_BUCK_DVS_SEL, mask[id],
+				  default_dvs_mode[id]);
 }
 
 static __devinit int lp8788_buck_probe(struct platform_device *pdev)
-- 
1.7.9.5



