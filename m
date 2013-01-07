Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3AGCpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:45:07 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58035 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3AGCpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:45:05 -0500
Date: Mon, 7 Jan 2013 10:44:56 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] block: Remove judgement for rq_mergeable(rq) in func elv_rqhash_find.
X-Priority: 3
X-GUID: B5E09863-29C6-4661-ADAA-6787A2213316
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201301071044518395740@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r072jJ5V024826

Because only mergeable rq can add rqhash.So it does not make sense to
judge rq_mergeable(rq) in func elv_rqhash_find.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/elevator.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 9edba1b..d5901a4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -273,11 +273,6 @@ static struct request *elv_rqhash_find(struct request_queue *q, sector_t offset)
 	hlist_for_each_entry_safe(rq, entry, next, hash_list, hash) {
 		BUG_ON(!ELV_ON_HASH(rq));
 
-		if (unlikely(!rq_mergeable(rq))) {
-			__elv_rqhash_del(rq);
-			continue;
-		}
-
 		if (rq_hash_key(rq) == offset)
 			return rq;
 	}
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
