Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2G0IBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 04:01:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49489 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2G0IA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 04:00:59 -0400
Date: Fri, 27 Jul 2012 16:02:10 +0800
From: majianpeng <majianpeng@gmail.com>
To: viro <viro@ZenIV.linux.org.uk>, "Neil Brown" <neilb@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: [RFC PATCH] fs/direct-io.c: Set bi_rw when alloc bio.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201207271602081096921@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6R81Y4V025754

When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
it will use bi_rw.
Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>> if ((bvm->bi_rw & 1) == WRITE)
>>		return biovec->bv_len; /* always allow writes to be mergeable */

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

There are many place like this in kernel.If you think this patch ok, i will correct those.
---
 fs/direct-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1faf4cb..77f0bbf 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -349,6 +349,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
+	bio->bi_rw = dio->rw;
 	if (dio->is_async)
 		bio->bi_end_io = dio_bio_end_aio;
 	else
-- 
1.7.5.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
