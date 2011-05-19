Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1ESBea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:34:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1ESBe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:34:28 -0400
Date: Thu, 19 May 2011 11:34:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20110519113425.bb478b3c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got conflicts in
drivers/block/paride/pcd.c and drivers/cdrom/viocd.c between commit
9fd097b14918 ("block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe
drivers") from Linus' tree and commit d4dc210f69bc ("block: don't block
events on excl write for non-optical devices") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/paride/pcd.c
index 8690e31,a0aabd9..0000000
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@@ -320,6 -320,8 +320,7 @@@ static void pcd_init_units(void
  		disk->first_minor = unit;
  		strcpy(disk->disk_name, cd->name);	/* umm... */
  		disk->fops = &pcd_bdops;
+ 		disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 -		disk->events = DISK_EVENT_MEDIA_CHANGE;
  	}
  }
  
diff --cc drivers/cdrom/viocd.c
index e427fbe,ae15a4d..0000000
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@@ -625,7 -625,9 +625,8 @@@ static int viocd_probe(struct vio_dev *
  	blk_queue_max_hw_sectors(q, 4096 / 512);
  	gendisk->queue = q;
  	gendisk->fops = &viocd_fops;
- 	gendisk->flags = GENHD_FL_CD|GENHD_FL_REMOVABLE;
+ 	gendisk->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE |
+ 			 GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 -	gendisk->events = DISK_EVENT_MEDIA_CHANGE;
  	set_capacity(gendisk, 0);
  	gendisk->private_data = d;
  	d->viocd_disk = gendisk;
