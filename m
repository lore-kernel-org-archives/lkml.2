Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab2HGDxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:53:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59644 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293Ab2HGDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:12 -0400
Message-Id: <20120807032758.543063775@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>,
        Greg KH <greg@kroah.com>
Subject: [ 17/70] usb: feed USB device information to the /dev/random driver
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b04b3156a20d395a7faa8eed98698d1e17a36000 upstream.

Send the USB device's serial, product, and manufacturer strings to the
/dev/random driver to help seed its pools.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -24,6 +24,7 @@
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -1897,6 +1898,14 @@ int usb_new_device(struct usb_device *ud
 	/* Tell the world! */
 	announce_device(udev);
 
+	if (udev->serial)
+		add_device_randomness(udev->serial, strlen(udev->serial));
+	if (udev->product)
+		add_device_randomness(udev->product, strlen(udev->product));
+	if (udev->manufacturer)
+		add_device_randomness(udev->manufacturer,
+				      strlen(udev->manufacturer));
+
 	device_enable_async_suspend(&udev->dev);
 	/* Register the device.  The device driver is responsible
 	 * for configuring the device and invoking the add-device


