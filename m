Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1CXNY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:24:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1CXNY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:24:28 -0400
Date: Thu, 24 Mar 2011 14:24:27 +0100
From: Libor Pechacek <lpechacek@suse.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: remove dead code from usb_deregister_dev()
Message-ID: <20110324132426.GA27561@fm.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18-muttng (2008-05-17-r1399)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `name' variable is unused in usb_deregister_dev() since commit d6e5bcf.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
---
 drivers/usb/core/file.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index cf6a542..99458c8 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -236,13 +236,6 @@ EXPORT_SYMBOL_GPL(usb_register_dev);
 void usb_deregister_dev(struct usb_interface *intf,
 			struct usb_class_driver *class_driver)
 {
-	int minor_base = class_driver->minor_base;
-	char name[20];
-
-#ifdef CONFIG_USB_DYNAMIC_MINORS
-	minor_base = 0;
-#endif
-
 	if (intf->minor == -1)
 		return;
 
@@ -252,7 +245,6 @@ void usb_deregister_dev(struct usb_interface *intf,
 	usb_minors[intf->minor] = NULL;
 	up_write(&minor_rwsem);
 
-	snprintf(name, sizeof(name), class_driver->name, intf->minor - minor_base);
 	device_destroy(usb_class->class, MKDEV(USB_MAJOR, intf->minor));
 	intf->usb_dev = NULL;
 	intf->minor = -1;
-- 
1.6.0.2

