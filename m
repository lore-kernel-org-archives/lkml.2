Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1DVVpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:45:33 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47466
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756772Ab1DVVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:43:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/21] Staging: hv: Get rid of the function blkvsc_revalidate_disk()
Date: Fri, 22 Apr 2011 14:55:13 -0700
Message-Id: <1303509326-3094-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block driver in Hyper-V does not support removable media, get rid of the
blkvsc_revalidate_disk().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 4c248b7..b2cd04a 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -722,22 +722,6 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 }
 
 
-static int blkvsc_revalidate_disk(struct gendisk *gd)
-{
-	struct block_device_context *blkdev = gd->private_data;
-
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-
-	if (blkdev->device_type == DVD_TYPE) {
-		blkvsc_do_operation(blkdev, DO_CAPACITY);
-		set_capacity(blkdev->gd, blkdev->capacity *
-			    (blkdev->sector_size/512));
-		blk_queue_logical_block_size(gd->queue, blkdev->sector_size);
-	}
-	return 0;
-}
-
-
 /*
  * We break the request into 1 or more blkvsc_requests and submit
  * them.  If we cant submit them all, we put them on the
@@ -997,7 +981,6 @@ static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
 	.open = blkvsc_open,
 	.release = blkvsc_release,
-	.revalidate_disk = blkvsc_revalidate_disk,
 	.getgeo = blkvsc_getgeo,
 	.ioctl  = blkvsc_ioctl,
 };
-- 
1.7.4.1

