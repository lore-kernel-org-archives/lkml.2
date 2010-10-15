Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0JORUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:20:38 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34969
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756616Ab0JORUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:20:32 -0400
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org
Subject: [PATCH 2/5] staging: hv: Convert camel cased function names in channel_interface.c to lower cases
Date: Fri, 15 Oct 2010 10:14:04 -0700
Message-Id: <1287162847-27536-2-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1287162847-27536-1-git-send-email-haiyangz@linuxonhyperv.com>
References: <1287162847-27536-1-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Convert camel cased function names in channel_interface.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_interface.c |   40 ++++++++++++++++----------------
 drivers/staging/hv/channel_interface.h |    2 +-
 drivers/staging/hv/vmbus.c             |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/channel_interface.c b/drivers/staging/hv/channel_interface.c
index d9d345e..abd7f7f 100644
--- a/drivers/staging/hv/channel_interface.c
+++ b/drivers/staging/hv/channel_interface.c
@@ -25,7 +25,7 @@
 #include "osd.h"
 #include "vmbus_private.h"
 
-static int IVmbusChannelOpen(struct hv_device *device, u32 sendbuffer_size,
+static int ivmbus_open(struct hv_device *device, u32 sendbuffer_size,
 			     u32 recv_ringbuffer_size, void *userdata,
 			     u32 userdatalen,
 			     void (*channel_callback)(void *context),
@@ -36,12 +36,12 @@ static int IVmbusChannelOpen(struct hv_device *device, u32 sendbuffer_size,
 				channel_callback, context);
 }
 
-static void IVmbusChannelClose(struct hv_device *device)
+static void ivmbus_close(struct hv_device *device)
 {
 	vmbus_close(device->context);
 }
 
-static int IVmbusChannelSendPacket(struct hv_device *device, const void *buffer,
+static int ivmbus_sendpacket(struct hv_device *device, const void *buffer,
 				   u32 bufferlen, u64 requestid, u32 type,
 				   u32 flags)
 {
@@ -49,7 +49,7 @@ static int IVmbusChannelSendPacket(struct hv_device *device, const void *buffer,
 				      requestid, type, flags);
 }
 
-static int IVmbusChannelSendPacketPageBuffer(struct hv_device *device,
+static int ivmbus_sendpacket_pagebuffer(struct hv_device *device,
 				struct hv_page_buffer pagebuffers[],
 				u32 pagecount, void *buffer,
 				u32 bufferlen, u64 requestid)
@@ -59,7 +59,7 @@ static int IVmbusChannelSendPacketPageBuffer(struct hv_device *device,
 						requestid);
 }
 
-static int IVmbusChannelSendPacketMultiPageBuffer(struct hv_device *device,
+static int ivmbus_sendpacket_multipagebuffer(struct hv_device *device,
 				struct hv_multipage_buffer *multi_pagebuffer,
 				void *buffer, u32 bufferlen, u64 requestid)
 {
@@ -68,7 +68,7 @@ static int IVmbusChannelSendPacketMultiPageBuffer(struct hv_device *device,
 						     bufferlen, requestid);
 }
 
-static int IVmbusChannelRecvPacket(struct hv_device *device, void *buffer,
+static int ivmbus_recvpacket(struct hv_device *device, void *buffer,
 				   u32 bufferlen, u32 *buffer_actuallen,
 				   u64 *requestid)
 {
@@ -76,7 +76,7 @@ static int IVmbusChannelRecvPacket(struct hv_device *device, void *buffer,
 				      buffer_actuallen, requestid);
 }
 
-static int IVmbusChannelRecvPacketRaw(struct hv_device *device, void *buffer,
+static int ivmbus_recvpacket_raw(struct hv_device *device, void *buffer,
 				      u32 bufferlen, u32 *buffer_actuallen,
 				      u64 *requestid)
 {
@@ -84,14 +84,14 @@ static int IVmbusChannelRecvPacketRaw(struct hv_device *device, void *buffer,
 					 buffer_actuallen, requestid);
 }
 
-static int IVmbusChannelEstablishGpadl(struct hv_device *device, void *buffer,
+static int ivmbus_establish_gpadl(struct hv_device *device, void *buffer,
 				       u32 bufferlen, u32 *gpadl_handle)
 {
 	return vmbus_establish_gpadl(device->context, buffer, bufferlen,
 					  gpadl_handle);
 }
 
-static int IVmbusChannelTeardownGpadl(struct hv_device *device,
+static int ivmbus_teardown_gpadl(struct hv_device *device,
 				      u32 gpadl_handle)
 {
 	return vmbus_teardown_gpadl(device->context, gpadl_handle);
@@ -99,7 +99,7 @@ static int IVmbusChannelTeardownGpadl(struct hv_device *device,
 }
 
 
-void GetChannelInfo(struct hv_device *device, struct hv_device_info *info)
+void get_channel_info(struct hv_device *device, struct hv_device_info *info)
 {
 	struct vmbus_channel_debug_info debug_info;
 
@@ -142,14 +142,14 @@ void GetChannelInfo(struct hv_device *device, struct hv_device_info *info)
 
 /* vmbus interface function pointer table */
 const struct vmbus_channel_interface vmbus_ops = {
-	.Open = IVmbusChannelOpen,
-	.Close = IVmbusChannelClose,
-	.SendPacket = IVmbusChannelSendPacket,
-	.SendPacketPageBuffer = IVmbusChannelSendPacketPageBuffer,
-	.SendPacketMultiPageBuffer = IVmbusChannelSendPacketMultiPageBuffer,
-	.RecvPacket = IVmbusChannelRecvPacket,
-	.RecvPacketRaw	= IVmbusChannelRecvPacketRaw,
-	.EstablishGpadl = IVmbusChannelEstablishGpadl,
-	.TeardownGpadl = IVmbusChannelTeardownGpadl,
-	.GetInfo = GetChannelInfo,
+	.Open = ivmbus_open,
+	.Close = ivmbus_close,
+	.SendPacket = ivmbus_sendpacket,
+	.SendPacketPageBuffer = ivmbus_sendpacket_pagebuffer,
+	.SendPacketMultiPageBuffer = ivmbus_sendpacket_multipagebuffer,
+	.RecvPacket = ivmbus_recvpacket,
+	.RecvPacketRaw	= ivmbus_recvpacket_raw,
+	.EstablishGpadl = ivmbus_establish_gpadl,
+	.TeardownGpadl = ivmbus_teardown_gpadl,
+	.GetInfo = get_channel_info,
 };
diff --git a/drivers/staging/hv/channel_interface.h b/drivers/staging/hv/channel_interface.h
index ec88219..1007612 100644
--- a/drivers/staging/hv/channel_interface.h
+++ b/drivers/staging/hv/channel_interface.h
@@ -27,7 +27,7 @@
 
 #include "vmbus_api.h"
 
-void GetChannelInfo(struct hv_device *Device,
+void get_channel_info(struct hv_device *Device,
 		    struct hv_device_info *DeviceInfo);
 
 #endif /* _CHANNEL_INTERFACE_H_ */
diff --git a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
index ea2698c..0f2e1be 100644
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -66,7 +66,7 @@ static void VmbusGetChannelOffers(void)
 static void VmbusGetChannelInfo(struct hv_device *DeviceObject,
 				struct hv_device_info *DeviceInfo)
 {
-	GetChannelInfo(DeviceObject, DeviceInfo);
+	get_channel_info(DeviceObject, DeviceInfo);
 }
 
 /*
-- 
1.6.3.2

