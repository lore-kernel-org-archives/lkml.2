Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2JVJNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:13:51 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38259 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JVJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:13:50 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 17:13:48 +0800
Message-ID: <CAPgLHd_WQ_uRDV_yYcQ1GoN301bkGMYkYpg2Jqfts+n=Yr82XQ@mail.gmail.com>
Subject: [PATCH] aoe: remove unused variable in resend()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ecashin@coraid.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable ah is initialized but never used
otherwise, so remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/aoe/aoecmd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 3804a0a..812eb8a 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -425,7 +425,6 @@ resend(struct aoedev *d, struct frame *f)
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
 	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
 	struct aoetgt *t;
 	char buf[128];
 	u32 n;
@@ -440,7 +439,6 @@ resend(struct aoedev *d, struct frame *f)
 		return;
 	}
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	ah = (struct aoe_atahdr *) (h+1);
 
 	snprintf(buf, sizeof buf,
 		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",

