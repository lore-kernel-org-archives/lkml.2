Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2LTTUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:20:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21402 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2LTTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] m2m-deinterlace: use correct check for kzalloc failure
Date: Thu, 20 Dec 2012 14:11:18 -0500
Message-Id: <1356030701-16284-10-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in PTR_ERR()ing a NULL pointer, use a real error
instead.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/media/platform/m2m-deinterlace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 05c560f..64db74e 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -917,10 +917,8 @@ static int deinterlace_open(struct file *file)
 	ctx->xt = kzalloc(sizeof(struct dma_async_tx_descriptor) +
 				sizeof(struct data_chunk), GFP_KERNEL);
 	if (!ctx->xt) {
-		int ret = PTR_ERR(ctx->xt);
-
 		kfree(ctx);
-		return ret;
+		return -ENOMEM;
 	}
 
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
-- 
1.8.0

