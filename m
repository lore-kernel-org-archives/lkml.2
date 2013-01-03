Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3ACGce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:32:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38842 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3ACGcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:32:32 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] lp8788-ldo: fix a parent device on devm_gpio_request()
Thread-Topic: [PATCH 5/5] lp8788-ldo: fix a parent device on
 devm_gpio_request()
Thread-Index: Ac3pfBhBLkDz03MtT1SGvzttiTHq9g==
Date: Thu, 3 Jan 2013 06:32:26 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1102C@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
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

 Use 'platform_device' rather than i2c client device node.
 Argument is added in lp8788_config_ldo_enable_mode().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp8788-ldo.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 40403e9..416bb60 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -616,10 +616,11 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 	},
 };
 
-static int lp8788_gpio_request_ldo_en(struct lp8788_ldo *ldo,
+static int lp8788_gpio_request_ldo_en(struct platform_device *pdev,
+				struct lp8788_ldo *ldo,
 				enum lp8788_ext_ldo_en_id id)
 {
-	struct device *dev = ldo->lp->dev;
+	struct device *dev = &pdev->dev;
 	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
 	int ret, gpio, pinstate;
 	char *name[] = {
@@ -647,7 +648,8 @@ static int lp8788_gpio_request_ldo_en(struct lp8788_ldo *ldo,
 	return ret;
 }
 
-static int lp8788_config_ldo_enable_mode(struct lp8788_ldo *ldo,
+static int lp8788_config_ldo_enable_mode(struct platform_device *pdev,
+					struct lp8788_ldo *ldo,
 					enum lp8788_ldo_id id)
 {
 	int ret;
@@ -693,7 +695,7 @@ static int lp8788_config_ldo_enable_mode(struct lp8788_ldo *ldo,
 
 	ldo->en_pin = pdata->ldo_pin[enable_id];
 
-	ret = lp8788_gpio_request_ldo_en(ldo, enable_id);
+	ret = lp8788_gpio_request_ldo_en(pdev, ldo, enable_id);
 	if (ret)
 		goto set_default_ldo_enable_mode;
 
@@ -717,7 +719,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ldo->lp = lp;
-	ret = lp8788_config_ldo_enable_mode(ldo, lp8788_dldo_id[id]);
+	ret = lp8788_config_ldo_enable_mode(pdev, ldo, lp8788_dldo_id[id]);
 	if (ret)
 		return ret;
 
@@ -773,7 +775,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ldo->lp = lp;
-	ret = lp8788_config_ldo_enable_mode(ldo, lp8788_aldo_id[id]);
+	ret = lp8788_config_ldo_enable_mode(pdev, ldo, lp8788_aldo_id[id]);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5


Best Regards,
Milo


