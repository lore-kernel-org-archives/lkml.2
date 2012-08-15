Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2HOT5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:57:50 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63171 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2HOTw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 159/165] usb: feed USB device information to the /dev/random driver
Date: Wed, 15 Aug 2012 15:48:23 -0400
Message-ID: <1345060109-9187-160-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b04b3156a20d395a7faa8eed98698d1e17a36000 upstream.

Send the USB device's serial, product, and manufacturer strings to the
/dev/random driver to help seed its pools.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/hub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 40815d0..953269f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 #include <linux/pm_runtime.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -1827,6 +1828,14 @@ int usb_new_device(struct usb_device *udev)
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
-- 
1.7.12.rc2

