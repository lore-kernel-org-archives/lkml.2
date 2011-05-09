Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1EIWLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:11:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47339
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751707Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 019/206] Staging: hv: Get rid of the calls to storvsc_cleanup
Date: Mon,  9 May 2011 14:55:01 -0700
Message-Id: <1304978288-22999-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The storvsc_cleanup() is an empty function; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    3 ---
 drivers/staging/hv/storvsc.c     |    7 -------
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    1 -
 4 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index bca36b5..2e69af0 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -886,7 +886,6 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void blkvsc_drv_exit(void)
 {
-	struct storvsc_driver *storvsc_drv = &blkvsc_drv;
 	struct hv_driver *drv = &blkvsc_drv.base;
 	struct device *current_dev;
 	int ret;
@@ -911,8 +910,6 @@ static void blkvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	storvsc_cleanup(&storvsc_drv->base);
-
 	vmbus_child_driver_unregister(&drv->driver);
 
 	return;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 867eba1..7074520 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -660,10 +660,3 @@ int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
 	return -ENODEV;
 }
 
-/*
- * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
- */
-void storvsc_cleanup(struct hv_driver *driver)
-{
-}
-
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index f8c724b..84ee5a9 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -169,7 +169,6 @@ int storvsc_dev_remove(struct hv_device *device);
 
 int storvsc_do_io(struct hv_device *device,
 				struct hv_storvsc_request *request);
-void storvsc_cleanup(struct hv_driver *driver);
 
 int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
 				struct storvsc_major_info *major_info);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 799231c..c54a5fe 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -115,7 +115,6 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 	/* Setup the dispatch table */
 	stor_driver->base.dev_add	= storvsc_dev_add;
 	stor_driver->base.dev_rm	= storvsc_dev_remove;
-	stor_driver->base.cleanup	= storvsc_cleanup;
 
 	stor_driver->on_io_request	= storvsc_do_io;
 
-- 
1.7.4.1

