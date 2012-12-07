Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab2LGJZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:25:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47668 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789Ab2LGJZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:25:19 -0500
Message-ID: <1354872313.15243.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: lp8788-buck: Kill _gpio_request function
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 17:25:13 +0800
In-Reply-To: <1354872181.15243.1.camel@phoenix>
References: <1354872181.15243.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply use devm_gpio_request_one() instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-buck.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index d33b81a..369b034 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -429,18 +429,6 @@ static struct regulator_desc lp8788_buck_desc[] = {
 	},
 };
 
-static int _gpio_request(struct lp8788_buck *buck, int gpio, char *name)
-{
-	struct device *dev = buck->lp->dev;
-
-	if (!gpio_is_valid(gpio)) {
-		dev_err(dev, "invalid gpio: %d\n", gpio);
-		return -EINVAL;
-	}
-
-	return devm_gpio_request_one(dev, gpio, DVS_LOW, name);
-}
-
 static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
 				enum lp8788_buck_id id)
 {
@@ -452,7 +440,8 @@ static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
 	switch (id) {
 	case BUCK1:
 		gpio = pdata->buck1_dvs->gpio;
-		ret = _gpio_request(buck, gpio, b1_name);
+		ret = devm_gpio_request_one(buck->lp->dev, gpio, DVS_LOW,
+					    b1_name);
 		if (ret)
 			return ret;
 
@@ -461,7 +450,8 @@ static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
 	case BUCK2:
 		for (i = 0 ; i < LP8788_NUM_BUCK2_DVS ; i++) {
 			gpio = pdata->buck2_dvs->gpio[i];
-			ret = _gpio_request(buck, gpio, b2_name[i]);
+			ret = devm_gpio_request_one(buck->lp->dev, gpio,
+						    DVS_LOW, b2_name[i]);
 			if (ret)
 				return ret;
 		}
-- 
1.7.9.5



