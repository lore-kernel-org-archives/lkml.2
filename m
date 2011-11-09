Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab1KJDVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:21:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933913Ab1KJDVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:21:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:04 2011
Message-Id: <20111109212704.735144394@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fabian Godehardt <fg@emlix.com>
Subject: [044/262] USB: g_printer: fix bug in unregistration
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Godehardt <fg@emlix.com>

commit 8582d86143c690c68cc42f996def466a035bee34 upstream.

The allocated chardevice region range is only 1 device but on
unregister it currently tries to deregister 2.

Found this while doing a insmod/rmmod/insmod/rm... of the module
which seemed to eat major numbers.

Signed-off-by: Fabian Godehardt <fg@emlix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/printer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1602,7 +1602,7 @@ cleanup(void)
 	if (status)
 		ERROR(dev, "usb_gadget_unregister_driver %x\n", status);
 
-	unregister_chrdev_region(g_printer_devno, 2);
+	unregister_chrdev_region(g_printer_devno, 1);
 	class_destroy(usb_gadget_class);
 	mutex_unlock(&usb_printer_gadget.lock_printer_io);
 }


