Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0LHAq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:29 -0500
Received: from kroah.org ([198.145.64.141]:45810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0LHAq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:28 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:24 2010
Message-Id: <20101208004424.515679462@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [001/127] block: Ensure physical block size is unsigned int
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 block/blk-settings.c   |    2 +-
 include/linux/blkdev.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -352,7 +352,7 @@ EXPORT_SYMBOL(blk_queue_logical_block_si
  *   hardware can operate on without reverting to read-modify-write
  *   operations.
  */
-void blk_queue_physical_block_size(struct request_queue *q, unsigned short size)
+void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
 {
 	q->limits.physical_block_size = size;
 
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -932,7 +932,7 @@ extern void blk_queue_max_segment_size(s
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
-extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
@@ -1083,7 +1083,7 @@ static inline unsigned int queue_physica
 	return q->limits.physical_block_size;
 }
 
-static inline int bdev_physical_block_size(struct block_device *bdev)
+static inline unsigned int bdev_physical_block_size(struct block_device *bdev)
 {
 	return queue_physical_block_size(bdev_get_queue(bdev));
 }


