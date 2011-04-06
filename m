Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1DFW4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:56:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52198
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756617Ab1DFWyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 19/22] Staging: hv: Fix a jump label (Cleanup) in blkvsc_drv
Date: Wed,  6 Apr 2011 16:05:19 -0700
Message-Id: <1302131122-15530-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the goto labels was named Cleanup; change it to cleanup.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index bf8647e..a47581c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -963,7 +963,7 @@ static int blkvsc_probe(struct device *device)
 	blkdev = kzalloc(sizeof(struct block_device_context), GFP_KERNEL);
 	if (!blkdev) {
 		ret = -ENOMEM;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	INIT_LIST_HEAD(&blkdev->pending_list);
@@ -977,14 +977,14 @@ static int blkvsc_probe(struct device *device)
 					SLAB_HWCACHE_ALIGN, NULL);
 	if (!blkdev->request_pool) {
 		ret = -ENOMEM;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 
 	/* Call to the vsc driver to add the device */
 	ret = storvsc_drv_obj->base.dev_add(device_obj, &device_info);
 	if (ret != 0)
-		goto Cleanup;
+		goto cleanup;
 
 	blkdev->device_ctx = device_obj;
 	/* this identified the device 0 or 1 */
@@ -1027,7 +1027,7 @@ static int blkvsc_probe(struct device *device)
 		}
 	} else {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	DPRINT_INFO(BLKVSC_DRV, "blkvsc registered for major %d!!", major);
@@ -1035,7 +1035,7 @@ static int blkvsc_probe(struct device *device)
 	blkdev->gd = alloc_disk(BLKVSC_MINORS);
 	if (!blkdev->gd) {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	blkdev->gd->queue = blk_init_queue(blkvsc_request, &blkdev->lock);
@@ -1074,7 +1074,7 @@ static int blkvsc_probe(struct device *device)
 Remove:
 	storvsc_drv_obj->base.dev_rm(device_obj);
 
-Cleanup:
+cleanup:
 	if (blkdev) {
 		if (blkdev->request_pool) {
 			kmem_cache_destroy(blkdev->request_pool);
-- 
1.7.4.1

