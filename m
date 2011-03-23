Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1CWRku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:40:50 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51794
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756117Ab1CWRkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:39 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 12/16] Staging: hv: Cleanup initialization of blkvsc driver
Date: Wed, 23 Mar 2011 10:50:30 -0700
Message-Id: <1300902635-1347-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the initialization sequence for the block driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    8 ++++----
 drivers/staging/hv/storvsc_api.h |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 1d602a1..824080d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -155,7 +155,7 @@ static int blk_vsc_on_device_add(struct hv_device *device,
 }
 
 
-int blk_vsc_initialize(struct hv_driver *driver)
+static int blk_vsc_initialize(struct hv_driver *driver)
 {
 	struct storvsc_driver_object *stor_driver;
 	int ret = 0;
@@ -243,7 +243,7 @@ static const struct block_device_operations block_ops = {
 /*
  * blkvsc_drv_init -  BlkVsc driver initialization.
  */
-static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
+static int blkvsc_drv_init(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv;
 	struct hv_driver *drv = &g_blkvsc_drv.base;
@@ -254,7 +254,7 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv->priv = storvsc_drv_obj;
 
 	/* Callback to client driver to complete the initialization */
-	drv_init(&storvsc_drv_obj->base);
+	blk_vsc_initialize(&storvsc_drv_obj->base);
 
 	drv->driver.name = storvsc_drv_obj->base.name;
 
@@ -1552,7 +1552,7 @@ static int __init blkvsc_init(void)
 
 	DPRINT_INFO(BLKVSC_DRV, "Blkvsc initializing....");
 
-	ret = blkvsc_drv_init(blk_vsc_initialize);
+	ret = blkvsc_drv_init();
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 9a452f2..d985bbf 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -139,7 +139,6 @@ struct storvsc_device {
 
 /* Interface */
 int stor_vsc_on_host_reset(struct hv_device *device);
-int blk_vsc_initialize(struct hv_driver *driver);
 
 int stor_vsc_on_device_add(struct hv_device *device,
 				void *additional_info);
-- 
1.7.4.1

