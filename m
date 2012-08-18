Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2HRV1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:27:48 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61457 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab2HRV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:26:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,791,1336341600"; 
   d="scan'208";a="170194857"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: kernel-janitors@vger.kernel.org, Heungjun Kim <riverful.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/media/video/m5mols/m5mols_core.c: introduce missing initialization
Date: Sat, 18 Aug 2012 23:25:59 +0200
Message-Id: <1345325159-7365-5-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/video/m5mols/m5mols_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index ac7d28b..0f521f5 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -937,7 +937,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	if (!ret)
 		ret = m5mols_init_controls(sd);
 
-	m5mols_sensor_power(info, false);
+	ret = m5mols_sensor_power(info, false);
 	if (!ret)
 		return 0;
 out_me:

