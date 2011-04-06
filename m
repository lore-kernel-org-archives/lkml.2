Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1DFWyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:54:07 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:59613
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756332Ab1DFWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/22] Staging: hv: Enable blkvsc_ioctl()
Date: Wed,  6 Apr 2011 16:05:02 -0700
Message-Id: <1302131122-15530-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can support HDIO_GET_IDENTITY ioctl, enable blkvsc_ioctl().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3a344d2..3b47495 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -413,23 +413,18 @@ static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 
 
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
-			unsigned cmd, unsigned long argument)
+			unsigned cmd, unsigned long arg)
 {
-	int ret;
+	struct block_device_context *blkdev = bd->bd_disk->private_data;
+	int ret = 0;
 
 	switch (cmd) {
-	/*
-	 * TODO: I think there is certain format for HDIO_GET_IDENTITY rather
-	 * than just a GUID. Commented it out for now.
-	 */
-#if 0
 	case HDIO_GET_IDENTITY:
 		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY\n");
 		if (copy_to_user((void __user *)arg, blkdev->device_id,
 				 blkdev->device_id_len))
 			ret = -EFAULT;
 		break;
-#endif
 	default:
 		ret = -EINVAL;
 		break;
-- 
1.7.4.1

