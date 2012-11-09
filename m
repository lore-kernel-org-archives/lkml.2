Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2KIPiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:38:13 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44769 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2KIPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:38:10 -0500
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: Use NUMA_NO_NODE instead of -1
Date: Fri,  9 Nov 2012 12:37:44 -0300
Message-Id: <1352475464-11951-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 block/blk-core.c |    2 +-
 block/genhd.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..c9563ca 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -551,7 +551,7 @@ void blk_exit_rl(struct request_list *rl)
 
 struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 {
-	return blk_alloc_queue_node(gfp_mask, -1);
+	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
diff --git a/block/genhd.c b/block/genhd.c
index cac7366..e842bdc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1245,7 +1245,7 @@ EXPORT_SYMBOL(blk_lookup_devt);
 
 struct gendisk *alloc_disk(int minors)
 {
-	return alloc_disk_node(minors, -1);
+	return alloc_disk_node(minors, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(alloc_disk);
 
-- 
1.7.8.6

