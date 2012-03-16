Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161692Ab2CPHk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:40:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50136 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161614Ab2CPHkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:40:20 -0400
Message-ID: <4F62EE5E.5070207@kernel.org>
Date: Fri, 16 Mar 2012 15:40:14 +0800
From: Shaohua Li <shli@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC]blk: mark discard request sync
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: blk: mark discard request sync

discard is called in jbd for example. If discard is slowed down, all
file operations could be impacted (eg, journal is full). And we always
wait for discard to finish. So looks we should mark discard as sync.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  block/blk-lib.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/block/blk-lib.c
===================================================================
--- linux.orig/block/blk-lib.c	2012-03-16 10:20:49.621517546 +0800
+++ linux/block/blk-lib.c	2012-03-16 10:21:55.901517256 +0800
@@ -42,7 +42,7 @@ int blkdev_issue_discard(struct block_de
  {
  	DECLARE_COMPLETION_ONSTACK(wait);
  	struct request_queue *q = bdev_get_queue(bdev);
-	int type = REQ_WRITE | REQ_DISCARD;
+	int type = REQ_WRITE | REQ_DISCARD | REQ_SYNC;
  	unsigned int max_discard_sectors;
  	struct bio_batch bb;
  	struct bio *bio;
