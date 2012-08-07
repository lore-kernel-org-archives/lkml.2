Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2HGJZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:25:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2HGJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:25:45 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-93-5020df18383f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo(Woogyom) Kim'" <milo.kim@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 3/3] backlight: lp855x: remove goto err_sysfs and goto
 err_dev
Date: Tue, 07 Aug 2012 18:25:44 +0900
Message-id: <000701cd747e$9ec822f0$dc5868d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac10fp615JBuAHNvTg+zgzGSAs2e7g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQV2J+woBBp9aJS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG6x/9gr9cFWta25kaGL9xdDFyckgImEi0z2xkhLDFJC7cW8/W
	xcjFISQwnVHiSe9VVghnNpPEvseNLCBVbAJqEl++HGYHsUUEIiSaZ8xiBrGZBcol/ty+BxYX
	FgiWmLB/MxuIzSKgKnH+yQawOK+ArcSx5auhbEGJH5PvsUD0akms33mcCcKWl9i85i3QTA6g
	i9QlHv3VBTFFBPQk5jyOh6gQkdj34h3jBEaBWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERyUz6R3MK5qsDjEKMDBqMTDO1NFIUCINbGsuDL3EKMEB7OSCO/h
	nUAh3pTEyqrUovz4otKc1OJDjNIcLErivCbeX/2FBNITS1KzU1MLUotgskwcnFINjPGbWe8J
	qWjqNpy79nBJ2Yo043sykZOavnUW1NUWlmZcEubaIne21ivw/FzeaasETE9wfXry6sZ6y6OW
	C98fzwnOO1babzZph+hGofXPnrKn2b1IDb+34XOo6uOew3vDT+e+Z47WbuOOud138tKSq+pR
	yrLNS9ZIJi29nZr59Pf+DaKPF97LaVBiKc5INNRiLipOBADIL2aYRgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto err_sysfs and goto err_dev, which makes code
a bit smaller.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp855x_bl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index aa6d4f7..f9645fe 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -272,29 +272,25 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
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
1.7.1


