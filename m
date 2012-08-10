Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab2HJLq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:46:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43577 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2HJLq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:46:27 -0400
Date: Fri, 10 Aug 2012 19:46:45 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Shaohua Li" <shli@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] block: Remove unnecessary requests sort.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208101946429067463@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7ABkXNu032421

When adding request to plug,it already sort.So there is not unnecessary.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 034f186..9dbdef6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2879,13 +2879,6 @@ void blk_start_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_start_plug);
 
-static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
-{
-	struct request *rqa = container_of(a, struct request, queuelist);
-	struct request *rqb = container_of(b, struct request, queuelist);
-
-	return !(rqa->q <= rqb->q);
-}
 
 /*
  * If 'from_schedule' is true, then postpone the dispatch of requests
@@ -2980,11 +2973,6 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	list_splice_init(&plug->list, &list);
 
-	if (plug->should_sort) {
-		list_sort(NULL, &list, plug_rq_cmp);
-		plug->should_sort = 0;
-	}
-
 	q = NULL;
 	depth = 0;
 
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
