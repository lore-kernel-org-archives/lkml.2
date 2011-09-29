Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1I2SeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:34:24 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35801
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754628Ab1I2ScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:18 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 15/24] Staging: hv: mousevsc: Get rid of mousevsc_on_send_completion()
Date: Thu, 29 Sep 2011 11:54:55 -0700
Message-Id: <1317322504-9788-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to handle the "send complete" callback - nothing needs to be done
here; get rid of the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 38e31ae..fc0ba68 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -288,25 +288,6 @@ static struct mousevsc_dev *final_release_input_device(struct hv_device *device)
 	return input_dev;
 }
 
-static void mousevsc_on_send_completion(struct hv_device *device,
-					struct vmpacket_descriptor *packet)
-{
-	struct mousevsc_dev *input_dev;
-	void *request;
-
-	input_dev = must_get_input_device(device);
-	if (!input_dev)
-		return;
-
-	request = (void *)(unsigned long)packet->trans_id;
-
-	if (request == &input_dev->protocol_req) {
-		/* FIXME */
-		/* Shouldn't we be doing something here? */
-	}
-
-	put_input_device(device);
-}
 
 static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 				struct synthhid_device_info *device_info)
@@ -480,8 +461,6 @@ static void mousevsc_on_channel_callback(void *context)
 
 				switch (desc->type) {
 				case VM_PKT_COMP:
-					mousevsc_on_send_completion(
-						device, desc);
 					break;
 
 				case VM_PKT_DATA_INBAND:
-- 
1.7.4.1

