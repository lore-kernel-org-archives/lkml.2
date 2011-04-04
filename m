Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1DDWhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:37:13 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34907
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755655Ab1DDWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:37:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/22] Staging: hv: Cleanup blkvsc_remove()
Date: Mon,  4 Apr 2011 15:48:02 -0700
Message-Id: <1301957291-8035-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301957291-8035-1-git-send-email-kys@microsoft.com>
References: <1301957186-7853-1-git-send-email-kys@microsoft.com>
 <1301957291-8035-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkvsc_remove() cannot fail. Clean it up accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 32d542d..c0a7acd 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -555,22 +555,12 @@ static int blkvsc_remove(struct device *device)
 	struct hv_device *device_obj = device_to_hv_device(device);
 	struct block_device_context *blkdev = dev_get_drvdata(device);
 	unsigned long flags;
-	int ret;
-
-
-	if (!storvsc_drv_obj->base.dev_rm)
-		return -1;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = storvsc_drv_obj->base.dev_rm(device_obj);
-	if (ret != 0) {
-		/* TODO: */
-		DPRINT_ERR(BLKVSC_DRV,
-			   "unable to remove blkvsc device (ret %d)", ret);
-	}
+	storvsc_drv_obj->base.dev_rm(device_obj);
 
 	/* Get to a known state */
 	spin_lock_irqsave(&blkdev->lock, flags);
@@ -603,7 +593,8 @@ static int blkvsc_remove(struct device *device)
 
 	kfree(blkdev);
 
-	return ret;
+	return 0;
+
 }
 
 static void blkvsc_shutdown(struct device *device)
-- 
1.7.4.1

