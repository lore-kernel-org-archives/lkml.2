Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1DFWyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:54:13 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52179
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756601Ab1DFWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/22] Staging: hv: Cleanup blkvsc_remove()
Date: Wed,  6 Apr 2011 16:05:13 -0700
Message-Id: <1302131122-15530-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
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
index 58d4a2d..7974e6c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -556,22 +556,12 @@ static int blkvsc_remove(struct device *device)
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
@@ -604,7 +594,8 @@ static int blkvsc_remove(struct device *device)
 
 	kfree(blkdev);
 
-	return ret;
+	return 0;
+
 }
 
 static void blkvsc_shutdown(struct device *device)
-- 
1.7.4.1

