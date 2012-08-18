Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab2HRV1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:27:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61443 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab2HRV0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:26:21 -0400
X-IronPort-AV: E=Sophos;i="4.77,791,1336341600"; 
   d="scan'208";a="170194854"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/media/video/mt9m032.c: introduce missing initialization
Date: Sat, 18 Aug 2012 23:25:56 +0200
Message-Id: <1345325159-7365-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The result of one call to a function is tested, and then at the second call
to the same function, the previous result, and not the current result, is
tested again.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
identifier f;
statement S1,S2;
@@

*ret = f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S1
... when any
*f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/video/mt9m032.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 445359c..f80c1d7 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -781,7 +781,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	ret = mt9m032_write(client, MT9M032_RESET, 1);	/* reset on */
 	if (ret < 0)
 		goto error_entity;
-	mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
+	ret = mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
 	if (ret < 0)
 		goto error_entity;
 

