Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1DWStk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:49:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47975 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1DWStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q4VPEXZ8dwUN3pQa09GsOA1poGVaDNQlB3FpQEqH7BZPqizBBYS/lKEd/m0lnFcPa5
         Db9C1gVc2sTT5OpaGFFQI4fWubbRTCKwApC8aCH0VvCAEjsjqW5NOBelsaZEsXXigcjQ
         YW0i1dJYoNl/TZizF8FfHEKcuF1zfxfjlXu0s=
From: Liu Yuan <namei.unix@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers, block: virtio_blk: Replace cryptic number with the macro
Date: Sun, 24 Apr 2011 02:49:26 +0800
Message-Id: <1303584566-11621-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

It is easier to figure out the context by reading SCSI_SENSE_BUFFERSIZE
instead of plain '96'.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 drivers/block/virtio_blk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6ecf89c..d6a426a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -6,6 +6,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
+#include <scsi/scsi_cmnd.h>
 
 #define PART_BITS 4
 
@@ -141,7 +142,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
 
 	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, 96);
+		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
 		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
 			   sizeof(vbr->in_hdr));
 	}
-- 
1.7.1

