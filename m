Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1DVVp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:45:27 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47496
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756781Ab1DVVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:43:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/21] Staging: hv: Get rid of some DPRINT_ERR() calls
Date: Fri, 22 Apr 2011 14:55:20 -0700
Message-Id: <1303509326-3094-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some DPRINT_ERR() calls.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 92614d5..35ad3d5 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -17,6 +17,8 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *
+ * 4/3/2011: K. Y. Srinivasan - Significant restructuring and cleanup.
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -967,7 +969,6 @@ static int blkvsc_probe(struct device *device)
 
 
 	if (!storvsc_drv_obj->base.dev_add) {
-		DPRINT_ERR(BLKVSC_DRV, "OnDeviceAdd() not set");
 		ret = -1;
 		goto Cleanup;
 	}
@@ -995,10 +996,8 @@ static int blkvsc_probe(struct device *device)
 
 	/* Call to the vsc driver to add the device */
 	ret = storvsc_drv_obj->base.dev_add(device_obj, &device_info);
-	if (ret != 0) {
-		DPRINT_ERR(BLKVSC_DRV, "unable to add blkvsc device");
+	if (ret != 0)
 		goto Cleanup;
-	}
 
 	blkdev->device_ctx = device_obj;
 	/* this identified the device 0 or 1 */
@@ -1040,7 +1039,6 @@ static int blkvsc_probe(struct device *device)
 			ide1_registered = 1;
 		}
 	} else {
-		DPRINT_ERR(BLKVSC_DRV, "invalid pathid");
 		ret = -1;
 		goto Cleanup;
 	}
@@ -1049,7 +1047,6 @@ static int blkvsc_probe(struct device *device)
 
 	blkdev->gd = alloc_disk(BLKVSC_MINORS);
 	if (!blkdev->gd) {
-		DPRINT_ERR(BLKVSC_DRV, "register_blkdev() failed! ret %d", ret);
 		ret = -1;
 		goto Cleanup;
 	}
-- 
1.7.4.1

