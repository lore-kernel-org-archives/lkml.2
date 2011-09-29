Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1I2ScT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:32:19 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42072
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753447Ab1I2ScR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:17 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 04/24] Staging: hv: mousevsc: Change the allocation flags to reflect interrupt context
Date: Thu, 29 Sep 2011 11:54:44 -0700
Message-Id: <1317322504-9788-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the allocation flags to reflect interrupt context.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 016d7e5..b7cc164 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -329,7 +329,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	desc = &device_info->hid_descriptor;
 	WARN_ON(desc->bLength == 0);
 
-	input_device->hid_desc = kzalloc(desc->bLength, GFP_KERNEL);
+	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
 
 	if (!input_device->hid_desc) {
 		pr_err("unable to allocate hid descriptor - size %d",
@@ -342,7 +342,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	/* Save the report desc */
 	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
 	input_device->report_desc = kzalloc(input_device->report_desc_size,
-					  GFP_KERNEL);
+					  GFP_ATOMIC);
 
 	if (!input_device->report_desc) {
 		pr_err("unable to allocate report descriptor - size %d",
@@ -541,7 +541,7 @@ static void mousevsc_on_channel_callback(void *context)
 		} else if (ret == -ENOBUFS) {
 			/* Handle large packet */
 			bufferlen = bytes_recvd;
-			buffer = kzalloc(bytes_recvd, GFP_KERNEL);
+			buffer = kzalloc(bytes_recvd, GFP_ATOMIC);
 
 			if (buffer == NULL) {
 				buffer = packet;
-- 
1.7.4.1

