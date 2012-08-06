Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2HFJfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:35:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60409 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2HFJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:35:06 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-0c-501f8fc4326b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo(Woogyom) Kim'" <milo.kim@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 3/3] backlight: lp855x: remove goto err_dev
Date: Mon, 06 Aug 2012 18:35:00 +0900
Message-id: <004001cd73b6$c011da50$40358ef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1ztr/7coLsb16/SeONd+CmjHJZPQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd0j/fIBBlMOWFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MpbNusRWs5ayYs+o6ewPjefYuRk4OCQETidYl61ghbDGJC/fW
	s3UxcnEICUxnlOhuOckO4cxmkviwdgsjSBWbgJrEly+HwbpFBCIkmmfMYgaxmQXKJf7cvgcW
	Fxawlmh7/wKsnkVAVWLziSVgG3gFbCV2PH0FZQtK/Jh8jwWiV0ti87YmVghbXmLzmrdAMzmA
	LlKXePRXF2KVnsTqNxuhykUk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEB+YzqR2MKxssDjEKcDAq8fDeNJAPEGJNLCuuzD3EKMHBrCTC29sM
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM5r7P3VX0ggPbEkNTs1tSC1CCbLxMEp1cDo6zHZ4kC2
	Xt/379N25p+RWVPDkr1g+dlgscc7vbdxZc5esvmPoWewrYK4IPeHtTYG5QfzLmSXRceabXyn
	+X7i+c/fNvXtloqaPZvx+pHyAi+52MVZK58uVjBj/macpfTaveCRfmfn7J28yznNBfc9fs0/
	/0y2+f1PH/iMyxSDwpmnzJm77O45JZbijERDLeai4kQA5G1ocUgCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto err_dev, which makes code a bit smaller.

Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp855x_bl.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index aa6d4f7..c629fa8 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -272,14 +272,14 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
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
@@ -293,7 +293,6 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 
 err_sysfs:
 	lp855x_backlight_unregister(lp);
-err_dev:
 	return ret;
 }
 
-- 
1.7.1


