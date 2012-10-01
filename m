Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2JAXJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:09:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35607 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222Ab2JAXCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:55 -0400
Message-Id: <20121001225204.989799835@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
        "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 174/180] usb: feed USB device information to the /dev/random driver
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b04b3156a20d395a7faa8eed98698d1e17a36000 upstream.

Send the USB device's serial, product, and manufacturer strings to the
/dev/random driver to help seed its pools.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/core/hub.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 069de19..02aad50 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 #include <linux/usb/quirks.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -1831,6 +1832,14 @@ int usb_new_device(struct usb_device *udev)
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
 	/* Register the device.  The device driver is responsible
 	 * for configuring the device and invoking the add-device
 	 * notifier chain (used by usbfs and possibly others).
-- 
1.7.2.1.45.g54fbc



