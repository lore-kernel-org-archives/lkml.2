Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab0HYP6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:58:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:52914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab0HYPyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:54:10 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/30] block/loop: queue ordered mode should be DRAIN_FLUSH
Date: Wed, 25 Aug 2010 17:47:19 +0200
Message-Id: <1282751267-3530-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 15:53:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop implements FLUSH using fsync but was incorrectly setting its
ordered mode to DRAIN.  Change it to DRAIN_FLUSH.  In practice, this
doesn't change anything as loop doesn't make use of the block layer
ordered implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/loop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f3c636d..c3a4a2e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -832,7 +832,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->lo_queue->unplug_fn = loop_unplug;
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN);
+		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN_FLUSH);
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
-- 
1.7.1

