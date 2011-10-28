Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab1J1Vqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:46:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48842
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933414Ab1J1Vqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:46:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/3] Staging: hv: mousevsc: Address some style issues
Date: Fri, 28 Oct 2011 15:11:26 -0700
Message-Id: <1319839888-29000-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319839847-28959-1-git-send-email-kys@microsoft.com>
References: <1319839847-28959-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deal with some style related issues. Also get rid of an unused macro.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index dd42411..7c7449b 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -115,7 +115,6 @@ struct synthhid_input_report {
 #define INPUTVSC_SEND_RING_BUFFER_SIZE		(10*PAGE_SIZE)
 #define INPUTVSC_RECV_RING_BUFFER_SIZE		(10*PAGE_SIZE)
 
-#define NBITS(x) (((x)/BITS_PER_LONG)+1)
 
 enum pipe_prot_msg_type {
 	PIPE_MESSAGE_INVALID,
@@ -146,6 +145,7 @@ struct  mousevsc_prt_msg {
 struct mousevsc_dev {
 	struct hv_device	*device;
 	bool			init_complete;
+	bool			connected;
 	struct mousevsc_prt_msg	protocol_req;
 	struct mousevsc_prt_msg	protocol_resp;
 	/* Synchronize the request/response if needed */
@@ -156,7 +156,6 @@ struct mousevsc_dev {
 	unsigned char		*report_desc;
 	u32			report_desc_size;
 	struct hv_input_dev_info hid_dev_info;
-	bool			connected;
 	struct hid_device       *hid_device;
 };
 
@@ -359,9 +358,9 @@ static void mousevsc_on_channel_callback(void *context)
 			bufferlen = bytes_recvd;
 			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
 
-			if (buffer == NULL) {
+			if (!buffer)
 				return;
-			}
+
 			break;
 		}
 	} while (1);
@@ -376,7 +375,6 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	struct mousevsc_prt_msg *request;
 	struct mousevsc_prt_msg *response;
 
-
 	request = &input_dev->protocol_req;
 
 	memset(request, 0, sizeof(struct mousevsc_prt_msg));
@@ -388,7 +386,6 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	request->request.header.size = sizeof(unsigned int);
 	request->request.version_requested.version = SYNTHHID_INPUT_VERSION;
 
-
 	ret = vmbus_sendpacket(device->channel, request,
 				sizeof(struct pipe_prt_msg) -
 				sizeof(unsigned char) +
@@ -396,11 +393,11 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 				(unsigned long)request,
 				VM_PKT_DATA_INBAND,
 				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0)
+	if (ret)
 		goto cleanup;
 
 	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
-	if (t == 0) {
+	if (!t) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -415,7 +412,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	}
 
 	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
-	if (t == 0) {
+	if (!t) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -487,7 +484,6 @@ static int mousevsc_probe(struct hv_device *device,
 		return ret;
 	}
 
-
 	ret = mousevsc_connect_to_vsp(device);
 
 	if (ret != 0)
-- 
1.7.4.1

