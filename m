Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2HTD5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:57:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab2HTD5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Henrik Rydberg <rydberg@bitmath.se>
Subject: [ 10/16] USB: add USB_VENDOR_AND_INTERFACE_INFO() macro
Date: Sun, 19 Aug 2012 20:56:09 -0700
Message-Id: <20120820035459.124021821@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035457.653002510@linuxfoundation.org>
References: <20120820035457.653002510@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit d81a5d1956731c453b85c141458d4ff5d6cc5366 upstream.

A lot of Broadcom Bluetooth devices provides vendor specific interface
class and we are getting flooded by patches adding new device support.
This change will help us enable support for any other Broadcom with vendor
specific device that arrives in the future.

Only the product id changes for those devices, so this macro would be
perfect for us:

{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) }

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Acked-by: Henrik Rydberg <rydberg@bitmath.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/usb.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -757,6 +757,27 @@ static inline int usb_make_path(struct u
 	.bInterfaceSubClass = (sc), \
 	.bInterfaceProtocol = (pr)
 
+/**
+ * USB_VENDOR_AND_INTERFACE_INFO - describe a specific usb vendor with a class of usb interfaces
+ * @vend: the 16 bit USB Vendor ID
+ * @cl: bInterfaceClass value
+ * @sc: bInterfaceSubClass value
+ * @pr: bInterfaceProtocol value
+ *
+ * This macro is used to create a struct usb_device_id that matches a
+ * specific vendor with a specific class of interfaces.
+ *
+ * This is especially useful when explicitly matching devices that have
+ * vendor specific bDeviceClass values, but standards-compliant interfaces.
+ */
+#define USB_VENDOR_AND_INTERFACE_INFO(vend, cl, sc, pr) \
+	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
+		| USB_DEVICE_ID_MATCH_VENDOR, \
+	.idVendor = (vend), \
+	.bInterfaceClass = (cl), \
+	.bInterfaceSubClass = (sc), \
+	.bInterfaceProtocol = (pr)
+
 /* ----------------------------------------------------------------------- */
 
 /* Stuff for dynamic usb ids */


