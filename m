Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0HYP6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:58:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:52910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab0HYPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:54:09 -0400
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
Subject: [PATCH 15/30] virtio_blk: drop REQ_HARDBARRIER support
Date: Wed, 25 Aug 2010 17:47:32 +0200
Message-Id: <1282751267-3530-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 15:53:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove now unused REQ_HARDBARRIER support.  virtio_blk already
supports REQ_FLUSH and the usefulness of REQ_FUA for virtio_blk is
questionable at this point, so there's nothing else to do to support
new REQ_FLUSH/FUA interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/block/virtio_blk.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index d10b635..1260628 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -128,9 +128,6 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	if (vbr->req->cmd_flags & REQ_HARDBARRIER)
-		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
-
 	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
 	/*
@@ -388,13 +385,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	/*
-	 * If the FLUSH feature is supported we do have support for
-	 * flushing a volatile write cache on the host.  Use that to
-	 * implement write barrier support; otherwise, we must assume
-	 * that the host does not perform any kind of volatile write
-	 * caching.
-	 */
+	/* configure queue flush support */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
 		blk_queue_flush(q, REQ_FLUSH);
 
@@ -515,9 +506,9 @@ static const struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
-	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
+	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
 };
 
 /*
-- 
1.7.1

