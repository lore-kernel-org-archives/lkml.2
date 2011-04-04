Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1DDWiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:38:52 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48982
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755853Ab1DDWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:37:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 16/22] Staging: hv: Get rid of some DPRINT_ERR() calls
Date: Mon,  4 Apr 2011 15:48:05 -0700
Message-Id: <1301957291-8035-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301957291-8035-1-git-send-email-kys@microsoft.com>
References: <1301957186-7853-1-git-send-email-kys@microsoft.com>
 <1301957291-8035-1-git-send-email-kys@microsoft.com>
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
index 03aebfc..aff6356 100644
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
@@ -966,7 +968,6 @@ static int blkvsc_probe(struct device *device)
 
 
 	if (!storvsc_drv_obj->base.dev_add) {
-		DPRINT_ERR(BLKVSC_DRV, "OnDeviceAdd() not set");
 		ret = -1;
 		goto Cleanup;
 	}
@@ -994,10 +995,8 @@ static int blkvsc_probe(struct device *device)
 
 	/* Call to the vsc driver to add the device */
 	ret = storvsc_drv_obj->base.dev_add(device_obj, &device_info);
-	if (ret != 0) {
-		DPRINT_ERR(BLKVSC_DRV, "unable to add blkvsc device");
+	if (ret != 0)
 		goto Cleanup;
-	}
 
 	blkdev->device_ctx = device_obj;
 	/* this identified the device 0 or 1 */
@@ -1039,7 +1038,6 @@ static int blkvsc_probe(struct device *device)
 			ide1_registered = 1;
 		}
 	} else {
-		DPRINT_ERR(BLKVSC_DRV, "invalid pathid");
 		ret = -1;
 		goto Cleanup;
 	}
@@ -1048,7 +1046,6 @@ static int blkvsc_probe(struct device *device)
 
 	blkdev->gd = alloc_disk(BLKVSC_MINORS);
 	if (!blkdev->gd) {
-		DPRINT_ERR(BLKVSC_DRV, "register_blkdev() failed! ret %d", ret);
 		ret = -1;
 		goto Cleanup;
 	}
-- 
1.7.4.1

