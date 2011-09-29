Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1I2SdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:33:07 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35896
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756569Ab1I2ScU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:20 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 24/24] Staging: hv: mousevsc: Get rid of unnecessary comments
Date: Thu, 29 Sep 2011 11:55:04 -0700
Message-Id: <1317322504-9788-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unnecessary comments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 71b460b..edbb479 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -26,9 +26,6 @@
 #include "hyperv.h"
 
 
-/*
- * Data types
- */
 struct hv_input_dev_info {
 	unsigned int size;
 	unsigned short vendor;
@@ -137,9 +134,6 @@ struct pipe_prt_msg {
 	char data[1];
 };
 
-/*
- * Data types
- */
 struct  mousevsc_prt_msg {
 	enum pipe_prot_msg_type type;
 	u32 size;
@@ -206,11 +200,9 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	/* Assume success for now */
 	input_device->dev_info_status = 0;
 
-	/* Save the device attr */
 	memcpy(&input_device->hid_dev_info, &device_info->hid_dev_info,
 		sizeof(struct hv_input_dev_info));
 
-	/* Save the hid desc */
 	desc = &device_info->hid_descriptor;
 	WARN_ON(desc->bLength == 0);
 
@@ -221,7 +213,6 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 
 	memcpy(input_device->hid_desc, desc, desc->bLength);
 
-	/* Save the report desc */
 	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
 	if (input_device->report_desc_size == 0)
 		goto cleanup;
@@ -368,10 +359,6 @@ static void mousevsc_on_channel_callback(void *context)
 					bufferlen = packetSize;
 				}
 			} else {
-				/*
-				 * pr_debug("nothing else to read...");
-				 * reset
-				 */
 				if (bufferlen > packetSize) {
 					kfree(buffer);
 
@@ -388,8 +375,6 @@ static void mousevsc_on_channel_callback(void *context)
 			if (buffer == NULL) {
 				buffer = packet;
 				bufferlen = packetSize;
-
-				/* Try again next time around */
 				break;
 			}
 		}
@@ -409,9 +394,6 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 
 	request = &input_dev->protocol_req;
 
-	/*
-	 * Now, initiate the vsc/vsp initialization protocol on the open channel
-	 */
 	memset(request, 0, sizeof(struct mousevsc_prt_msg));
 
 	request->type = PIPE_MESSAGE_DATA;
@@ -525,7 +507,6 @@ static int mousevsc_on_device_add(struct hv_device *device)
 
 	input_dev->init_complete = false;
 
-	/* Open the channel */
 	ret = vmbus_open(device->channel,
 		INPUTVSC_SEND_RING_BUFFER_SIZE,
 		INPUTVSC_RECV_RING_BUFFER_SIZE,
@@ -550,7 +531,6 @@ static int mousevsc_on_device_add(struct hv_device *device)
 	}
 
 
-	/* Send the report desc back up */
 	/* workaround SA-167 */
 	if (input_dev->report_desc[14] == 0x25)
 		input_dev->report_desc[14] = 0x29;
@@ -567,7 +547,6 @@ static int mousevsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
 
-	/* Call to the vsc driver to add the device */
 	return mousevsc_on_device_add(dev);
 
 }
-- 
1.7.4.1

