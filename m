Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2IEEjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:39:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42309 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2IEEjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:39:32 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] regulator: lp872x: initialize the DVS mode
Thread-Topic: [PATCH 3/5] regulator: lp872x: initialize the DVS mode
Thread-Index: Ac2LIGxBe0H2IypkTsWpKx09gFfCYw==
Date: Wed, 5 Sep 2012 04:39:23 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF21D8@DQHE02.ent.ti.com>
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

 The platform specific configuration(general_config) is optional.
 However, the DVS settings should be configured explicitly while
 loading the driver.
 This patch enables configuring the default DVS mode even though
 the platform data is not defined.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index d86b6a3..b16a941 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -796,13 +796,14 @@ static int lp872x_config(struct lp872x *lp)
 	struct lp872x_platform_data *pdata = lp->pdata;
 	int ret;
 
-	if (!pdata->update_config)
-		return 0;
+	if (!pdata || !pdata->update_config)
+		goto init_dvs;
 
 	ret = lp872x_write_byte(lp, LP872X_GENERAL_CFG, pdata->general_config);
 	if (ret)
 		return ret;
 
+init_dvs:
 	return lp872x_init_dvs(lp);
 }
 
-- 
1.7.9.5


Best Regards,
Milo


