Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1EIWNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:13:14 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47299
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751543Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 011/206] Staging: hv: Rename the function stor_vsc_device_add
Date: Mon,  9 May 2011 14:54:53 -0700
Message-Id: <1304978288-22999-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    2 +-
 drivers/staging/hv/storvsc_api.h |    2 +-
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 434c2a9..908c169 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -147,7 +147,7 @@ static int blkvsc_device_add(struct hv_device *device,
 
 	device_info = (struct storvsc_device_info *)additional_info;
 
-	ret = stor_vsc_on_device_add(device, additional_info);
+	ret = storvsc_dev_add(device, additional_info);
 	if (ret != 0)
 		return ret;
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6be504b..503c6bf 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -442,7 +442,7 @@ static int stor_vsc_connect_to_vsp(struct hv_device *device)
  * stor_vsc_on_device_add - Callback when the device belonging to this driver
  * is added
  */
-int stor_vsc_on_device_add(struct hv_device *device,
+int storvsc_dev_add(struct hv_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 4ebf50a..0200154 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -163,7 +163,7 @@ struct storvsc_driver *drv_to_stordrv(struct device_driver *d)
 
 /* Interface */
 
-int stor_vsc_on_device_add(struct hv_device *device,
+int storvsc_dev_add(struct hv_device *device,
 				void *additional_info);
 int stor_vsc_on_device_remove(struct hv_device *device);
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 1fce10e..5168eb7 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -113,7 +113,7 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 		    STORVSC_MAX_IO_REQUESTS);
 
 	/* Setup the dispatch table */
-	stor_driver->base.dev_add	= stor_vsc_on_device_add;
+	stor_driver->base.dev_add	= storvsc_dev_add;
 	stor_driver->base.dev_rm	= stor_vsc_on_device_remove;
 	stor_driver->base.cleanup	= stor_vsc_on_cleanup;
 
-- 
1.7.4.1

