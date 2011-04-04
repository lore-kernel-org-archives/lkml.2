Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1DDWj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:39:29 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33591
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755790Ab1DDWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:37:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/22] Staging: hv: Get rid of the code to manage removable media
Date: Mon,  4 Apr 2011 15:48:04 -0700
Message-Id: <1301957291-8035-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301957291-8035-1-git-send-email-kys@microsoft.com>
References: <1301957186-7853-1-git-send-email-kys@microsoft.com>
 <1301957291-8035-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hyper-V block driver does not handle removable media.
Get rid of the code to manage removable media.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index c0a7acd..03aebfc 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -436,8 +436,6 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 
 		if (device_type == 0x0)
 			blkdev->device_type = HARDDISK_TYPE;
-		 else if (device_type == 0x5)
-			blkdev->device_type = DVD_TYPE;
 		 else
 			blkdev->device_type = UNKNOWN_DEV_TYPE;
 
@@ -1074,12 +1072,7 @@ static int blkvsc_probe(struct device *device)
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
 	blkvsc_do_operation(blkdev, DO_INQUIRY);
-	if (blkdev->device_type == DVD_TYPE) {
-		set_disk_ro(blkdev->gd, 1);
-		blkdev->gd->flags |= GENHD_FL_REMOVABLE;
-		blkvsc_do_operation(blkdev, DO_CAPACITY);
-	} else
-		blkvsc_do_operation(blkdev, DO_CAPACITY);
+	blkvsc_do_operation(blkdev, DO_CAPACITY);
 
 	set_capacity(blkdev->gd, blkdev->capacity * (blkdev->sector_size/512));
 	blk_queue_logical_block_size(blkdev->gd->queue, blkdev->sector_size);
-- 
1.7.4.1

