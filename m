Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2FTSVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab2FTSVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:12 -0400
Message-Id: <20120620173021.595992372@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>
Subject: [ 07/61] drm/udl: only bind to the video devices on the hub.
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit e5a867a51d9b009f90d5dca6a320608e4e8a37ec upstream.

This is ported from udlfb.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=832188
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_drv.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -13,8 +13,21 @@
 
 static struct drm_driver driver;
 
+/*
+ * There are many DisplayLink-based graphics products, all with unique PIDs.
+ * So we match on DisplayLink's VID + Vendor-Defined Interface Class (0xff)
+ * We also require a match on SubClass (0x00) and Protocol (0x00),
+ * which is compatible with all known USB 2.0 era graphics chips and firmware,
+ * but allows DisplayLink to increment those for any future incompatible chips
+ */
 static struct usb_device_id id_table[] = {
-	{.idVendor = 0x17e9, .match_flags = USB_DEVICE_ID_MATCH_VENDOR,},
+	{.idVendor = 0x17e9, .bInterfaceClass = 0xff,
+	 .bInterfaceSubClass = 0x00,
+	 .bInterfaceProtocol = 0x00,
+	 .match_flags = USB_DEVICE_ID_MATCH_VENDOR |
+			USB_DEVICE_ID_MATCH_INT_CLASS |
+			USB_DEVICE_ID_MATCH_INT_SUBCLASS |
+			USB_DEVICE_ID_MATCH_INT_PROTOCOL,},
 	{},
 };
 MODULE_DEVICE_TABLE(usb, id_table);


