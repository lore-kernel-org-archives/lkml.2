Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1I2X6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:58:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51660
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752511Ab1I2X6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:58:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 03/24] Staging: hv: mousevsc: Fixup some bogus WARN_ON() calls
Date: Thu, 29 Sep 2011 11:54:43 -0700
Message-Id: <1317322504-9788-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the bogus WARN_ON() calls.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 69eb00e..016d7e5 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -200,7 +200,7 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 
 static void free_input_device(struct mousevsc_dev *device)
 {
-	WARN_ON(atomic_read(&device->ref_count) == 0);
+	WARN_ON(atomic_read(&device->ref_count) != 0);
 	kfree(device);
 }
 
@@ -327,7 +327,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 
 	/* Save the hid desc */
 	desc = &device_info->hid_descriptor;
-	WARN_ON(desc->bLength > 0);
+	WARN_ON(desc->bLength == 0);
 
 	input_device->hid_desc = kzalloc(desc->bLength, GFP_KERNEL);
 
@@ -447,7 +447,7 @@ static void mousevsc_on_receive(struct hv_device *device,
 		break;
 
 	case SynthHidInitialDeviceInfo:
-		WARN_ON(pipe_msg->size >= sizeof(struct hv_input_dev_info));
+		WARN_ON(pipe_msg->size < sizeof(struct hv_input_dev_info));
 
 		/*
 		 * Parse out the device info into device attr,
-- 
1.7.4.1

