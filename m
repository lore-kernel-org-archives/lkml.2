Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2HFVVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:21:11 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:44972 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab2HFVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:21:08 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, Yann Cantin <yann.cantin@laposte.net>
Subject: [RFC ebeam PATCH v3 1/2] hid: Blacklist new eBeam classic device
Date: Mon,  6 Aug 2012 23:21:43 +0200
Message-Id: <1344288104-20731-2-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
---
 drivers/hid/hid-core.c |    3 +++
 drivers/hid/hid-ids.h  |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 60ea284..b1ed8ee 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1908,6 +1908,9 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
+#if defined(CONFIG_INPUT_EBEAM_USB)
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_CLASSIC) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1dcb76f..b985059 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -271,6 +271,9 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
+#define USB_VENDOR_ID_EFI		0x2650
+#define USB_DEVICE_ID_EFI_CLASSIC	0x1311
+
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
 
-- 
1.7.10

