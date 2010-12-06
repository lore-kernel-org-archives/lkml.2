Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0LFUaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:30:01 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40422
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753242Ab0LFU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:57 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 8/8] staging: hv: Convert camel case local variables in blkvsc.c to lowercase
Date: Mon,  6 Dec 2010 12:26:51 -0800
Message-Id: <1291667211-1865-8-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-7-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-4-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-5-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-6-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-7-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel case local variables in blkvsc.c to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c |   52 +++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 4f4a65c..bc16d91 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -25,24 +25,24 @@
 #include "osd.h"
 #include "storvsc.c"
 
-static const char *gBlkDriverName = "blkvsc";
+static const char *g_blk_driver_name = "blkvsc";
 
 /* {32412632-86cb-44a2-9b5c-50d1417354f5} */
-static const struct hv_guid gBlkVscDeviceType = {
+static const struct hv_guid g_blk_device_type = {
 	.data = {
 		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
 		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
 	}
 };
 
-static int blk_vsc_on_device_add(struct hv_device *Device, void *AdditionalInfo)
+static int blk_vsc_on_device_add(struct hv_device *device, void *additional_info)
 {
-	struct storvsc_device_info *deviceInfo;
+	struct storvsc_device_info *device_info;
 	int ret = 0;
 
-	deviceInfo = (struct storvsc_device_info *)AdditionalInfo;
+	device_info = (struct storvsc_device_info *)additional_info;
 
-	ret = stor_vsc_on_device_add(Device, AdditionalInfo);
+	ret = stor_vsc_on_device_add(device, additional_info);
 	if (ret != 0)
 		return ret;
 
@@ -51,31 +51,31 @@ static int blk_vsc_on_device_add(struct hv_device *Device, void *AdditionalInfo)
 	 * id. For IDE devices, the device instance id is formatted as
 	 * <bus id> * - <device id> - 8899 - 000000000000.
 	 */
-	deviceInfo->path_id = Device->deviceInstance.data[3] << 24 |
-			     Device->deviceInstance.data[2] << 16 |
-			     Device->deviceInstance.data[1] << 8  |
-			     Device->deviceInstance.data[0];
+	device_info->path_id = device->deviceInstance.data[3] << 24 |
+			     device->deviceInstance.data[2] << 16 |
+			     device->deviceInstance.data[1] << 8  |
+			     device->deviceInstance.data[0];
 
-	deviceInfo->target_id = Device->deviceInstance.data[5] << 8 |
-			       Device->deviceInstance.data[4];
+	device_info->target_id = device->deviceInstance.data[5] << 8 |
+			       device->deviceInstance.data[4];
 
 	return ret;
 }
 
-int blk_vsc_initialize(struct hv_driver *Driver)
+int blk_vsc_initialize(struct hv_driver *driver)
 {
-	struct storvsc_driver_object *storDriver;
+	struct storvsc_driver_object *stor_driver;
 	int ret = 0;
 
-	storDriver = (struct storvsc_driver_object *)Driver;
+	stor_driver = (struct storvsc_driver_object *)driver;
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
-	/* ASSERT(storDriver->RingBufferSize >= (PAGE_SIZE << 1)); */
+	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
-	Driver->name = gBlkDriverName;
-	memcpy(&Driver->deviceType, &gBlkVscDeviceType, sizeof(struct hv_guid));
+	driver->name = g_blk_driver_name;
+	memcpy(&driver->deviceType, &g_blk_device_type, sizeof(struct hv_guid));
 
-	storDriver->request_ext_size = sizeof(struct storvsc_request_extension);
+	stor_driver->request_ext_size = sizeof(struct storvsc_request_extension);
 
 	/*
 	 * Divide the ring buffer data size (which is 1 page less than the ring
@@ -83,20 +83,20 @@ int blk_vsc_initialize(struct hv_driver *Driver)
 	 * by the max request size (which is
 	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
-	storDriver->max_outstanding_req_per_channel =
-		((storDriver->ring_buffer_size - PAGE_SIZE) /
+	stor_driver->max_outstanding_req_per_channel =
+		((stor_driver->ring_buffer_size - PAGE_SIZE) /
 		  ALIGN_UP(MAX_MULTIPAGE_BUFFER_PACKET +
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
 	DPRINT_INFO(BLKVSC, "max io outstd %u",
-		    storDriver->max_outstanding_req_per_channel);
+		    stor_driver->max_outstanding_req_per_channel);
 
 	/* Setup the dispatch table */
-	storDriver->base.OnDeviceAdd = blk_vsc_on_device_add;
-	storDriver->base.OnDeviceRemove = stor_vsc_on_device_remove;
-	storDriver->base.OnCleanup = stor_vsc_on_cleanup;
-	storDriver->on_io_request = stor_vsc_on_io_request;
+	stor_driver->base.OnDeviceAdd = blk_vsc_on_device_add;
+	stor_driver->base.OnDeviceRemove = stor_vsc_on_device_remove;
+	stor_driver->base.OnCleanup = stor_vsc_on_cleanup;
+	stor_driver->on_io_request = stor_vsc_on_io_request;
 
 	return ret;
 }
-- 
1.6.0.2

