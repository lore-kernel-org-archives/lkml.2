Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1HQJYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:24:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1HQJYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:24:01 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        WANG Cong <amwang@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 5/5] nbd: replace some printk with dev_warn() and dev_info()
Date: Wed, 17 Aug 2011 17:22:43 +0800
Message-Id: <1313572963-3440-5-git-send-email-amwang@redhat.com>
In-Reply-To: <1313572963-3440-1-git-send-email-amwang@redhat.com>
References: <1313572963-3440-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>


Signed-off-by: WANG Cong <amwang@redhat.com>
---
 drivers/block/nbd.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 2b5fc11..3353d98 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -127,8 +127,7 @@ static void sock_shutdown(struct nbd_device *lo, int lock)
 	if (lock)
 		mutex_lock(&lo->tx_lock);
 	if (lo->sock) {
-		printk(KERN_WARNING "%s: shutting down socket\n",
-			lo->disk->disk_name);
+		dev_warn(disk_to_dev(lo->disk), "shutting down socket\n");
 		kernel_sock_shutdown(lo->sock, SHUT_RDWR);
 		lo->sock = NULL;
 	}
@@ -576,7 +575,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 	case NBD_DISCONNECT: {
 		struct request sreq;
 
-	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
+	        dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");
 
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
@@ -674,7 +673,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		file = lo->file;
 		lo->file = NULL;
 		nbd_clear_que(lo);
-		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+		dev_warn(disk_to_dev(lo->disk), "queue cleared\n");
 		if (file)
 			fput(file);
 		lo->bytesize = 0;
@@ -694,8 +693,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		return 0;
 
 	case NBD_PRINT_DEBUG:
-		printk(KERN_INFO "%s: next = %p, prev = %p, head = %p\n",
-			bdev->bd_disk->disk_name,
+		dev_info(disk_to_dev(lo->disk),
+			"next = %p, prev = %p, head = %p\n",
 			lo->queue_head.next, lo->queue_head.prev,
 			&lo->queue_head);
 		return 0;
-- 
1.7.4.4

