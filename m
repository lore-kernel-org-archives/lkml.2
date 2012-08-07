Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2HGIcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:32:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38232 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2HGIc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:32:29 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] backlight: lp855x: remove goto err_dev
Thread-Topic: [PATCH 3/3] backlight: lp855x: remove goto err_dev
Thread-Index: Ac1ztr/7coLsb16/SeONd+CmjHJZPQAvsEsA
Date: Tue, 7 Aug 2012 08:32:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FEBF3@DQHE02.ent.ti.com>
References: <004001cd73b6$c011da50$40358ef0$%han@samsung.com>
In-Reply-To: <004001cd73b6$c011da50$40358ef0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.104]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch removes goto err_dev, which makes code a bit smaller.

Thanks !
IMO, goto statements are meaningful on _probe().
However, 'goto err_sysfs' also can be removed if the size of code is critical.

drivers/video/backlight/lp855x_bl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 72a0e0c..7e4198c 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -268,29 +268,25 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (ret) {
 		dev_err(lp->dev, "i2c communication err: %d", ret);
 		if (mode == REGISTER_BASED)
-			goto err_dev;
+			return ret;
 	}
 
 	ret = lp855x_backlight_register(lp);
 	if (ret) {
 		dev_err(lp->dev,
 			"failed to register backlight. err: %d\n", ret);
-		goto err_dev;
+		return ret;
 	}
 
 	ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
 	if (ret) {
 		dev_err(lp->dev, "failed to register sysfs. err: %d\n", ret);
-		goto err_sysfs;
+		lp855x_backlight_unregister(lp);
+		return ret;
 	}
 
 	backlight_update_status(lp->bl);
 	return 0;
-
-err_sysfs:
-	lp855x_backlight_unregister(lp);
-err_dev:
-	return ret;
 }
 
 static int __devexit lp855x_remove(struct i2c_client *cl)
-- 
1.7.2.5

Best Regards,
Milo


