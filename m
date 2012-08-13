Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2HMUgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:36:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2HMUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <greg@kroah.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 49/82] usb: feed USB device information to the /dev/random driver
Date: Mon, 13 Aug 2012 13:19:25 -0700
Message-Id: <20120813201750.746191768@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b04b3156a20d395a7faa8eed98698d1e17a36000 upstream.

Send the USB device's serial, product, and manufacturer strings to the
/dev/random driver to help seed its pools.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -2173,6 +2174,14 @@ int usb_new_device(struct usb_device *ud
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
 
 	/*


