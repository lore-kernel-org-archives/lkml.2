Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1JNHy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:54:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33275 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1JNHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:54:58 -0400
From: Benson Leung <bleung@chromium.org>
To: jkosina@suse.cz, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH] HID: usbhid: enable remote wakeup for mice
Date: Fri, 14 Oct 2011 00:54:48 -0700
Message-Id: <1318578888-7599-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables remote wakeup by default on USB mouse
devices. This only covers USB mice that support
the boot protocol. See commit 3d61510f for the
equivalent patch for USB keyboard devices.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/hid/usbhid/hid-core.c |    8 ++++----
 drivers/hid/usbhid/usbmouse.c |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b403fce..02a66f1 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1073,10 +1073,10 @@ static int usbhid_start(struct hid_device *hid)
 	 * In addition, enable remote wakeup by default for all keyboard
 	 * devices supporting the boot protocol.
 	 */
-	if (interface->desc.bInterfaceSubClass == USB_INTERFACE_SUBCLASS_BOOT &&
-			interface->desc.bInterfaceProtocol ==
-				USB_INTERFACE_PROTOCOL_KEYBOARD) {
-		usbhid_set_leds(hid);
+	if (interface->desc.bInterfaceSubClass == USB_INTERFACE_SUBCLASS_BOOT) {
+		if (interface->desc.bInterfaceProtocol ==
+				USB_INTERFACE_PROTOCOL_KEYBOARD)
+			usbhid_set_leds(hid);
 		device_set_wakeup_enable(&dev->dev, 1);
 	}
 	return 0;
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index 79b2bf8..6ca3321 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -200,6 +200,7 @@ static int usb_mouse_probe(struct usb_interface *intf, const struct usb_device_i
 		goto fail3;
 
 	usb_set_intfdata(intf, mouse);
+	device_set_wakeup_enable(&dev->dev, 1);
 	return 0;
 
 fail3:	
-- 
1.7.1

