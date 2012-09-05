Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2IEEjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:39:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40072 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2IEEjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:39:45 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] regulator: lp872x: remove unnecessary function
Thread-Topic: [PATCH 5/5] regulator: lp872x: remove unnecessary function
Thread-Index: Ac2LIHUa8xQSz8RfSPyvQ9N0LczHGQ==
Date: Wed, 5 Sep 2012 04:39:39 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF21E8@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The lp872x_check_dvs_validity() is used for checking DVS platform data.
 If the DVS platform data is not defined, return as error code.
 Now, this is unnecessary because the default DVS mode is set in this case.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 86485e8..708f4b6 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -729,28 +729,6 @@ static struct regulator_desc lp8725_regulator_desc[] = {
 	},
 };
 
-static int lp872x_check_dvs_validity(struct lp872x *lp)
-{
-	struct lp872x_dvs *dvs = lp->pdata->dvs;
-	u8 val = 0;
-	int ret;
-
-	ret = lp872x_read_byte(lp, LP872X_GENERAL_CFG, &val);
-	if (ret)
-		return ret;
-
-	ret = 0;
-	if (lp->chipid == LP8720) {
-		if (val & LP8720_EXT_DVS_M)
-			ret = dvs ? 0 : -EINVAL;
-	} else {
-		if ((val & LP8725_DVS1_M) == EXTERN_DVS_USED)
-			ret = dvs ? 0 : -EINVAL;
-	}
-
-	return ret;
-}
-
 static int lp872x_init_dvs(struct lp872x *lp)
 {
 	int ret, gpio;
@@ -762,12 +740,6 @@ static int lp872x_init_dvs(struct lp872x *lp)
 	if (!dvs)
 		goto set_default_dvs_mode;
 
-	ret = lp872x_check_dvs_validity(lp);
-	if (ret) {
-		dev_warn(lp->dev, "invalid dvs data: %d\n", ret);
-		return ret;
-	}
-
 	gpio = dvs->gpio;
 	if (!gpio_is_valid(gpio)) {
 		dev_err(lp->dev, "invalid gpio: %d\n", gpio);
-- 
1.7.9.5


Best Regards,
Milo


