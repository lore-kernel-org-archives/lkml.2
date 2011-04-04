Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1DDXJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:09:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52395
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755879Ab1DDXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:08:06 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 09/22] Staging: hv: Get rid of the function blkvsc_revalidate_disk()
Date: Mon,  4 Apr 2011 15:47:58 -0700
Message-Id: <1301957291-8035-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301957291-8035-1-git-send-email-kys@microsoft.com>
References: <1301957186-7853-1-git-send-email-kys@microsoft.com>
 <1301957291-8035-1-git-send-email-kys@microsoft.com>
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
index 1ea5f9c..da7fd38 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -721,22 +721,6 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
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
@@ -996,7 +980,6 @@ static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
 	.open = blkvsc_open,
 	.release = blkvsc_release,
-	.revalidate_disk = blkvsc_revalidate_disk,
 	.getgeo = blkvsc_getgeo,
 	.ioctl  = blkvsc_ioctl,
 };
-- 
1.7.4.1

