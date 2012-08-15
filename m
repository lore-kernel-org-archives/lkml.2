Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2HOTuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62885 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2HOTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jeremiah Matthey <sprg86@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 060/165] HID: usbhid: Add support for SiGma Micro chip
Date: Wed, 15 Aug 2012 15:46:44 -0400
Message-ID: <1345060109-9187-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremiah Matthey <sprg86@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f5e4282586dc0c9dab8c7d32e6c43aa07f68586b upstream.

Patch to add SiGma Micro-based keyboards (1c4f:0002) to hid-quirks.

These keyboards dont seem to allow the records to be initialized, and hence a
timeout occurs when the usbhid driver attempts to initialize them. The patch
just adds the signature for these keyboards to the hid-quirks list with the
setting HID_QUIRK_NO_INIT_REPORTS. This removes the 5-10 second wait for the
timeout to occur.

Signed-off-by: Jeremiah Matthey <sprg86@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hid-ids.h           | 3 +++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index fe054d6..459b457 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -417,6 +417,9 @@
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 
+#define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
+#define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
+
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 1152f9b..894c1a2 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -71,6 +71,7 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };
-- 
1.7.12.rc2

