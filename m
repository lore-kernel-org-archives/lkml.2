Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1DVVXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:23:39 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56234
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753609Ab1DVVXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:23:35 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/18] Staging: hv: Get rid of the forward declaration of blkvsc_ioctl()
Date: Fri, 22 Apr 2011 14:13:23 -0700
Message-Id: <1303506819-1913-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303506819-1913-1-git-send-email-kys@microsoft.com>
References: <1303506780-1872-1-git-send-email-kys@microsoft.com>
 <1303506819-1913-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_ioctl() by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   56 ++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index f4f6545..a0d3d6c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -407,6 +407,33 @@ static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 }
 
 
+static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
+			unsigned cmd, unsigned long argument)
+{
+/*	struct block_device_context *blkdev = bd->bd_disk->private_data; */
+	int ret;
+
+	switch (cmd) {
+	/*
+	 * TODO: I think there is certain format for HDIO_GET_IDENTITY rather
+	 * than just a GUID. Commented it out for now.
+	 */
+#if 0
+	case HDIO_GET_IDENTITY:
+		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY\n");
+		if (copy_to_user((void __user *)arg, blkdev->device_id,
+				 blkdev->device_id_len))
+			ret = -EFAULT;
+		break;
+#endif
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
@@ -414,8 +441,6 @@ static void blkvsc_shutdown(struct device *device);
 
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
-static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
-			unsigned cmd, unsigned long argument);
 static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
@@ -1499,33 +1524,6 @@ static int blkvsc_revalidate_disk(struct gendisk *gd)
 	return 0;
 }
 
-static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
-			unsigned cmd, unsigned long argument)
-{
-/*	struct block_device_context *blkdev = bd->bd_disk->private_data; */
-	int ret;
-
-	switch (cmd) {
-	/*
-	 * TODO: I think there is certain format for HDIO_GET_IDENTITY rather
-	 * than just a GUID. Commented it out for now.
-	 */
-#if 0
-	case HDIO_GET_IDENTITY:
-		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY\n");
-		if (copy_to_user((void __user *)arg, blkdev->device_id,
-				 blkdev->device_id_len))
-			ret = -EFAULT;
-		break;
-#endif
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
 static int __init blkvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

