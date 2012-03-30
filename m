Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936123Ab2C3Vb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:31:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966025Ab2C3VVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:33 -0400
Message-Id: <20120330194843.823582880@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Keng-Yu Lin <kengyu@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 094/175] HID: add extra hotkeys in Asus AIO keyboards
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keng-Yu Lin <kengyu@canonical.com>

commit 3596bb929f2abd3433c2eaa5755fad48ac207af1 upstream.

The Asus All-In-One PC has a wireless keyboard with wifi toggle,
brightness up, brightness down and display off hotkeys.

This patch adds suppoort for these hotkeys.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-chicony.c |    5 +++++
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-ids.h     |    1 +
 3 files changed, 7 insertions(+)

--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -45,6 +45,10 @@ static int ch_input_mapping(struct hid_d
 	case 0xff09: ch_map_key_clear(BTN_9);	break;
 	case 0xff0a: ch_map_key_clear(BTN_A);	break;
 	case 0xff0b: ch_map_key_clear(BTN_B);	break;
+	case 0x00f1: ch_map_key_clear(KEY_WLAN);	break;
+	case 0x00f2: ch_map_key_clear(KEY_BRIGHTNESSDOWN);	break;
+	case 0x00f3: ch_map_key_clear(KEY_BRIGHTNESSUP);	break;
+	case 0x00f4: ch_map_key_clear(KEY_DISPLAY_OFF);	break;
 	default:
 		return 0;
 	}
@@ -53,6 +57,7 @@ static int ch_input_mapping(struct hid_d
 
 static const struct hid_device_id ch_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ch_devices);
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1396,6 +1396,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT, USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH, USB_DEVICE_ID_CVTOUCH_SCREEN) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -193,6 +193,7 @@
 #define USB_DEVICE_ID_CHICONY_TACTICAL_PAD	0x0418
 #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
 #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
+#define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001


