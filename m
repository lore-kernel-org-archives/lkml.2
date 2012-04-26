Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab2DZAWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:22:43 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42282 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2DZAWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:22:41 -0400
Date: Wed, 25 Apr 2012 17:22:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [RFC PATCH] USB: rename the usb misc class from "usb" to "usbmisc"
Message-ID: <20120426002237.GA24935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This class was not named properly years ago, and it turns out that tools
like udev can't properly see the devices in this class after booting due
to the fact that there is a bus with the same name in the system.

Changing this to "usbmisc" fixes this problem, and it solves the problem
for the future when we want to unify classes and busses.

Reported-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index d95760d..8b63a51 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -92,7 +92,7 @@ static int init_usb_class(void)
 	}
 
 	kref_init(&usb_class->kref);
-	usb_class->class = class_create(THIS_MODULE, "usb");
+	usb_class->class = class_create(THIS_MODULE, "usbmisc");
 	if (IS_ERR(usb_class->class)) {
 		result = IS_ERR(usb_class->class);
 		printk(KERN_ERR "class_create failed for usb devices\n");
