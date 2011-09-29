Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab1I2TsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:48:15 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56981
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757175Ab1I2TsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:48:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 20/24]  Staging: hv: mousevsc: Cleanup camel cased enums
Date: Thu, 29 Sep 2011 11:55:00 -0700
Message-Id: <1317322504-9788-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup all camel cased names.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index e57e0b4..6621326 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -58,12 +58,12 @@ struct hv_input_dev_info {
  * Message types in the synthetic input protocol
  */
 enum synthhid_msg_type {
-	SynthHidProtocolRequest,
-	SynthHidProtocolResponse,
-	SynthHidInitialDeviceInfo,
-	SynthHidInitialDeviceInfoAck,
-	SynthHidInputReport,
-	SynthHidMax
+	SYNTH_HID_PROTOCOL_REQUEST,
+	SYNTH_HID_PROTOCOL_RESPONSE,
+	SYNTH_HID_INITIAL_DEVICE_INFO,
+	SYNTH_HID_INITIAL_DEVICE_INFO_ACK,
+	SYNTH_HID_INPUT_REPORT,
+	SYNTH_HID_MAX
 };
 
 /*
@@ -125,9 +125,9 @@ struct synthhid_input_report {
 #define NBITS(x) (((x)/BITS_PER_LONG)+1)
 
 enum pipe_prot_msg_type {
-	PipeMessageInvalid = 0,
-	PipeMessageData,
-	PipeMessageMaximum
+	PIPE_MESSAGE_INVALID,
+	PIPE_MESSAGE_DATA,
+	PIPE_MESSAGE_MAXIMUM
 };
 
 
@@ -238,10 +238,10 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	/* Send the ack */
 	memset(&ack, 0, sizeof(struct mousevsc_prt_msg));
 
-	ack.type = PipeMessageData;
+	ack.type = PIPE_MESSAGE_DATA;
 	ack.size = sizeof(struct synthhid_device_info_ack);
 
-	ack.ack.header.type = SynthHidInitialDeviceInfoAck;
+	ack.ack.header.type = SYNTH_HID_INITIAL_DEVICE_INFO_ACK;
 	ack.ack.header.size = 1;
 	ack.ack.reserved = 0;
 
@@ -296,20 +296,20 @@ static void mousevsc_on_receive(struct hv_device *device,
 	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
 						(packet->offset8 << 3));
 
-	if (pipe_msg->type != PipeMessageData)
+	if (pipe_msg->type != PIPE_MESSAGE_DATA)
 		return;
 
 	hid_msg = (struct synthhid_msg *)&pipe_msg->data[0];
 
 	switch (hid_msg->header.type) {
-	case SynthHidProtocolResponse:
+	case SYNTH_HID_PROTOCOL_RESPONSE:
 		memcpy(&input_dev->protocol_resp, pipe_msg,
 		       pipe_msg->size + sizeof(struct pipe_prt_msg) -
 		       sizeof(unsigned char));
 		complete(&input_dev->wait_event);
 		break;
 
-	case SynthHidInitialDeviceInfo:
+	case SYNTH_HID_INITIAL_DEVICE_INFO:
 		WARN_ON(pipe_msg->size < sizeof(struct hv_input_dev_info));
 
 		/*
@@ -319,7 +319,7 @@ static void mousevsc_on_receive(struct hv_device *device,
 		mousevsc_on_receive_device_info(input_dev,
 			(struct synthhid_device_info *)&pipe_msg->data[0]);
 		break;
-	case SynthHidInputReport:
+	case SYNTH_HID_INPUT_REPORT:
 		mousevsc_on_receive_input_report(input_dev,
 			(struct synthhid_input_report *)&pipe_msg->data[0]);
 
@@ -425,10 +425,10 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	 */
 	memset(request, 0, sizeof(struct mousevsc_prt_msg));
 
-	request->type = PipeMessageData;
+	request->type = PIPE_MESSAGE_DATA;
 	request->size = sizeof(struct synthhid_protocol_request);
 
-	request->request.header.type = SynthHidProtocolRequest;
+	request->request.header.type = SYNTH_HID_PROTOCOL_REQUEST;
 	request->request.header.size = sizeof(unsigned int);
 	request->request.version_requested.version = SYNTHHID_INPUT_VERSION;
 
-- 
1.7.4.1

