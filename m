Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0LLXpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0LLXo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:44:58 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: martin.petersen@oracle.com, snitzer@redhat.com, jaxboe@fusionio.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [1/223] block: Ensure physical block size is unsigned int
Message-Id: <20101212234455.BDD05B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:44:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Martin K. Petersen <martin.petersen@oracle.com>

commit 892b6f90db81cccb723d5d92f4fddc2d68b206e1 upstream.

Physical block size was declared unsigned int to accomodate the maximum
size reported by READ CAPACITY(16).  Make sure we use the right type in
the related functions.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/blk-settings.c   |    2 +-
 include/linux/blkdev.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/block/blk-settings.c
===================================================================
--- linux.orig/block/blk-settings.c
+++ linux/block/blk-settings.c
@@ -326,7 +326,7 @@ EXPORT_SYMBOL(blk_queue_logical_block_si
  *   hardware can operate on without reverting to read-modify-write
  *   operations.
  */
-void blk_queue_physical_block_size(struct request_queue *q, unsigned short size)
+void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
 {
 	q->limits.physical_block_size = size;
 
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -936,7 +936,7 @@ extern void blk_queue_max_segment_size(s
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
-extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
@@ -1086,7 +1086,7 @@ static inline unsigned int queue_physica
 	return q->limits.physical_block_size;
 }
 
-static inline int bdev_physical_block_size(struct block_device *bdev)
+static inline unsigned int bdev_physical_block_size(struct block_device *bdev)
 {
 	return queue_physical_block_size(bdev_get_queue(bdev));
 }
