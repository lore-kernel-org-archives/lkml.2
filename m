Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2FSMkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:40:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48373 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2FSMkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:40:18 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] HID: hid-multitouch: add support for Zytronic panels
Date: Tue, 19 Jun 2012 14:39:54 +0200
Message-Id: <1340109594-10732-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e9c68fe..bcaf3fa 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -393,6 +393,7 @@ config HID_MULTITOUCH
 	  - Unitec Panels
 	  - XAT optical touch panels
 	  - Xiroku optical touch panels
+	  - Zytronic touch panels
 
 	  If unsure, say N.
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 734a2b9..c77bfdd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -802,6 +802,9 @@
 #define USB_VENDOR_ID_ZYDACRON	0x13EC
 #define USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL	0x0006
 
+#define USB_VENDOR_ID_ZYTRONIC		0x14c8
+#define USB_DEVICE_ID_ZYTRONIC_ZXY100	0x0005
+
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index a5ef877..eb66abd 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1067,6 +1067,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
+	/* Zytronic panels */
+	{ .driver_data = MT_CLS_SERIAL,
+		MT_USB_DEVICE(USB_VENDOR_ID_ZYTRONIC,
+			USB_DEVICE_ID_ZYTRONIC_ZXY100) },
+
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
 	{ }
-- 
1.7.10.2

