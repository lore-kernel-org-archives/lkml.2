Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1CUX0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:26:43 -0400
Received: from kroah.org ([198.145.64.141]:52675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab1CUXSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:26 2011
Message-Id: <20110321230326.337552390@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [45/78] HID: add support for Ortek PKB-1700
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 270fdc0748bd3f7b625caff985f2fcf8e2185ec7 upstream.

As reported on http://ubuntuforums.org/showthread.php?t=1594007 the
PKB-1700 needs same special handling as WKB-2000. This change is
originally based on patch posted by user asmoore82 on the Ubuntu
forums.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig     |    4 ++--
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-ortek.c |    3 ++-
 4 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -319,10 +319,10 @@ config HID_NTRIG
 	Support for N-Trig touch screen.
 
 config HID_ORTEK
-	tristate "Ortek WKB-2000 wireless keyboard and mouse trackpad"
+	tristate "Ortek PKB-1700/WKB-2000 wireless keyboard and mouse trackpad"
 	depends on USB_HID
 	---help---
-	Support for Ortek WKB-2000 wireless keyboard + mouse trackpad.
+	Support for Ortek PKB-1700/WKB-2000 wireless keyboard + mouse trackpad.
 
 config HID_PANTHERLORD
 	tristate "Pantherlord/GreenAsia game controller"
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1400,6 +1400,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,6 +466,7 @@
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064
 
 #define USB_VENDOR_ID_ORTEK		0x05a4
+#define USB_DEVICE_ID_ORTEK_PKB1700	0x1700
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
 #define USB_VENDOR_ID_PANJIT		0x134c
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -1,5 +1,5 @@
 /*
- *  HID driver for Ortek WKB-2000 (wireless keyboard + mouse trackpad).
+ *  HID driver for Ortek PKB-1700/WKB-2000 (wireless keyboard + mouse trackpad).
  *  Fixes LogicalMaximum error in USB report description, see
  *  http://bugzilla.kernel.org/show_bug.cgi?id=14787
  *
@@ -30,6 +30,7 @@ static __u8 *ortek_report_fixup(struct h
 }
 
 static const struct hid_device_id ortek_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ }
 };


