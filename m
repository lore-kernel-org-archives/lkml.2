Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2E1Duv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:50:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51950 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab2E1D3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:19 -0400
Message-Id: <20120528031207.865243450@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [ 036/117] USB: move usb_translate_errors to linux/usb.h
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2c4d6bf295ae10ffcd84f0df6cb642598eb66603 upstream.

Move usb_translate_errors from usb core to linux/usb.h as it is meant to
be accessed from drivers.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/usb.h |   14 --------------
 include/linux/usb.h    |   13 +++++++++++++
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 3888778..45e8479 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -132,20 +132,6 @@ static inline int is_usb_device_driver(struct device_driver *drv)
 			for_devices;
 }
 
-/* translate USB error codes to codes user space understands */
-static inline int usb_translate_errors(int error_code)
-{
-	switch (error_code) {
-	case 0:
-	case -ENOMEM:
-	case -ENODEV:
-		return error_code;
-	default:
-		return -EIO;
-	}
-}
-
-
 /* for labeling diagnostics */
 extern const char *usbcore_name;
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index d3d0c13..2f05a7f 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1598,6 +1598,19 @@ usb_maxpacket(struct usb_device *udev, int pipe, int is_out)
 
 /* ----------------------------------------------------------------------- */
 
+/* translate USB error codes to codes user space understands */
+static inline int usb_translate_errors(int error_code)
+{
+	switch (error_code) {
+	case 0:
+	case -ENOMEM:
+	case -ENODEV:
+		return error_code;
+	default:
+		return -EIO;
+	}
+}
+
 /* Events from the usb core */
 #define USB_DEVICE_ADD		0x0001
 #define USB_DEVICE_REMOVE	0x0002


