Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2ARHm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:42:27 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:60824 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753023Ab2ARHm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:42:26 -0500
Date: Wed, 18 Jan 2012 15:30:05 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: [PATCH] eCryptfs: infinite loop bug
To: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 113.246.87.202
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <7e0cf36d898be996a126fa5fbb3bfe3c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0I7gmE9022589

Hi,
  There is an infinite loop bug in eCryptfs, to make it present,
just truncate to generate a huge file (>= 4G) on a 32-bit machine 
under the plain text foleder mounted with eCryptfs, a simple command
'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
therefore the following command 'truncate -s 4GB dummy' will not trigger this bug.
The bug comes from a data overflow, the patch below fixes it.

Cheers,
Li Wang

---

signed-off-by: Li Wang <liwang@nudt.edu.cn >
               Yunchuan Wen (wenyunchuan@kylinos.com.cn )

--- read_write.c.orig 2012-01-18 10:39:26.000000000 +0800
+++ read_write.c 2012-01-18 19:48:41.484196221 +0800
@@ -130,7 +130,7 @@ int ecryptfs_write(struct inode *ecryptf
   pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
   size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
   size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-  size_t total_remaining_bytes = ((offset + size) - pos);
+  loff_t total_remaining_bytes = ((offset + size) - pos);
 
   if (num_bytes > total_remaining_bytes)
    num_bytes = total_remaining_bytes;



--- read_write.c.orig	2012-01-18 10:39:26.000000000 +0800
+++ read_write.c	2012-01-18 19:48:41.484196221 +0800
@@ -130,7 +130,7 @@ int ecryptfs_write(struct inode *ecryptf
 		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
 		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
+		loff_t total_remaining_bytes = ((offset + size) - pos);
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
