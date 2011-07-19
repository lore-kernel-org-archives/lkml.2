Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1GSS7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:59:34 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52179
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751616Ab1GSS7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:59:32 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 5/8] Staging: hv: mousevsc: Fix checkpatch errors and warnings
Date: Tue, 19 Jul 2011 11:44:22 -0700
Message-Id: <1311101065-23417-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311101065-23417-1-git-send-email-kys@microsoft.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch errors and warnings.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   58 +++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 28bd2c5..e95bd3a 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -53,7 +53,7 @@ struct hv_input_dev_info {
 					 (SYNTHHID_INPUT_VERSION_MAJOR << 16))
 
 
-#pragma pack(push,1)
+#pragma pack(push, 1)
 /*
  * Message types in the synthetic input protocol
  */
@@ -119,8 +119,8 @@ struct synthhid_input_report {
 
 #pragma pack(pop)
 
-#define INPUTVSC_SEND_RING_BUFFER_SIZE		10*PAGE_SIZE
-#define INPUTVSC_RECV_RING_BUFFER_SIZE		10*PAGE_SIZE
+#define INPUTVSC_SEND_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
+#define INPUTVSC_RECV_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
 
 #define NBITS(x) (((x)/BITS_PER_LONG)+1)
 
@@ -177,7 +177,8 @@ struct mousevsc_dev {
 
 static const char *driver_name = "mousevsc";
 
-static void deviceinfo_callback(struct hv_device *dev, struct hv_input_dev_info *info);
+static void deviceinfo_callback(struct hv_device *dev,
+				 struct hv_input_dev_info *info);
 static void inputreport_callback(struct hv_device *dev, void *packet, u32 len);
 static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len);
 
@@ -336,7 +337,8 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	input_device->hid_desc = kzalloc(desc->bLength, GFP_KERNEL);
 
 	if (!input_device->hid_desc) {
-		pr_err("unable to allocate hid descriptor - size %d", desc->bLength);
+		pr_err("unable to allocate hid descriptor - size %d",
+			 desc->bLength);
 		goto cleanup;
 	}
 
@@ -502,22 +504,21 @@ static void mousevsc_on_channel_callback(void *context)
 				desc = (struct vmpacket_descriptor *)buffer;
 
 				switch (desc->type) {
-					case VM_PKT_COMP:
-						mousevsc_on_send_completion(
-							device, desc);
-						break;
-
-					case VM_PKT_DATA_INBAND:
-						mousevsc_on_receive(
-							device, desc);
-						break;
-
-					default:
-						pr_err("unhandled packet type %d, tid %llx len %d\n",
-							   desc->type,
-							   req_id,
-							   bytes_recvd);
-						break;
+				case VM_PKT_COMP:
+					mousevsc_on_send_completion(
+						device, desc);
+					break;
+
+				case VM_PKT_DATA_INBAND:
+					mousevsc_on_receive(
+						device, desc);
+					break;
+
+				default:
+					pr_err("unhandled packet type %d, tid %llx len %d\n",
+						desc->type, req_id,
+						bytes_recvd);
+					break;
 				}
 
 				/* reset */
@@ -596,12 +597,12 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	pr_info("synthhid protocol request...");
 
 	ret = vmbus_sendpacket(device->channel, request,
-					sizeof(struct pipe_prt_msg) -
-					sizeof(unsigned char) +
-					sizeof(struct synthhid_protocol_request),
-					(unsigned long)request,
-					VM_PKT_DATA_INBAND,
-					VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+				sizeof(struct pipe_prt_msg) -
+				sizeof(unsigned char) +
+				sizeof(struct synthhid_protocol_request),
+				(unsigned long)request,
+				VM_PKT_DATA_INBAND,
+				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		pr_err("unable to send synthhid protocol request.");
 		goto cleanup;
@@ -766,7 +767,8 @@ struct input_device_context {
 };
 
 
-static void deviceinfo_callback(struct hv_device *dev, struct hv_input_dev_info *info)
+static void deviceinfo_callback(struct hv_device *dev,
+				struct hv_input_dev_info *info)
 {
 	struct input_device_context *input_device_ctx =
 		dev_get_drvdata(&dev->device);
-- 
1.7.4.1

