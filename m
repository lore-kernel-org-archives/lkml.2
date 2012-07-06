Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab2GFWpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:45:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37440 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab2GFWpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:45:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
Subject: [PATCH 05/12] usb: feed USB device information to the /dev/random driver
Date: Fri,  6 Jul 2012 18:44:57 -0400
Message-Id: <1341614704-24965-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send the USB device's serial, product, and manufacturer strings to the
/dev/random driver to help seed its pools.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 drivers/usb/core/hub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 25a7422..7f380ff 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -24,6 +24,7 @@
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -2173,6 +2174,14 @@ int usb_new_device(struct usb_device *udev)
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
-- 
1.7.11.1.108.gb129051

