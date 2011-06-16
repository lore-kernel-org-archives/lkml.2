Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1FPUHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:07:46 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52303
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932328Ab1FPUCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:02 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 73/77] Staging: hv: mouse: Change the jump label Cleanup to cleanup
Date: Thu, 16 Jun 2011 13:17:46 -0700
Message-Id: <1308255470-3826-73-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the jump label Cleanup to cleanup.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 0338030..b04ba2c 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -339,7 +339,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 
 	if (!input_device->hid_desc) {
 		pr_err("unable to allocate hid descriptor - size %d", desc->bLength);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	memcpy(input_device->hid_desc, desc, desc->bLength);
@@ -352,7 +352,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	if (!input_device->report_desc) {
 		pr_err("unable to allocate report descriptor - size %d",
 			   input_device->report_desc_size);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	memcpy(input_device->report_desc,
@@ -379,7 +379,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	if (ret != 0) {
 		pr_err("unable to send synthhid device info ack - ret %d",
 			   ret);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	input_device->device_wait_condition = 1;
@@ -387,7 +387,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 
 	return;
 
-Cleanup:
+cleanup:
 	kfree(input_device->hid_desc);
 	input_device->hid_desc = NULL;
 
@@ -606,7 +606,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 					VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		pr_err("unable to send synthhid protocol request.");
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	input_dev->protocol_wait_condition = 0;
@@ -614,7 +614,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		input_dev->protocol_wait_condition, msecs_to_jiffies(1000));
 	if (input_dev->protocol_wait_condition == 0) {
 		ret = -ETIMEDOUT;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	response = &input_dev->protocol_resp;
@@ -623,7 +623,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		pr_err("synthhid protocol request failed (version %d)",
 		       SYNTHHID_INPUT_VERSION);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	input_dev->device_wait_condition = 0;
@@ -631,7 +631,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		input_dev->device_wait_condition, msecs_to_jiffies(1000));
 	if (input_dev->device_wait_condition == 0) {
 		ret = -ETIMEDOUT;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/*
@@ -643,7 +643,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	else
 		ret = -1;
 
-Cleanup:
+cleanup:
 	put_input_device(device);
 
 	return ret;
@@ -661,7 +661,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 
 	if (!input_dev) {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	input_dev->init_complete = false;
@@ -714,7 +714,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 
 	input_dev->init_complete = true;
 
-Cleanup:
+cleanup:
 	return ret;
 }
 
-- 
1.7.4.1

