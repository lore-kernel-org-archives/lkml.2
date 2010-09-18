Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0IRTCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:41 -0400
Received: from kroah.org ([198.145.64.141]:51312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab0IRTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:36 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185956.344220112@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, maximilian attems <max@stro.at>
Subject: [041/123] HID: usbhid: initialize interface pointers early enough
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=hid-usbhid-initialize-interface-pointers-early-enough.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 57ab12e418ec4fe24c11788bb1bbdabb29d05679 upstream.

Move the initialization of USB interface pointers from _start()
over to _probe() callback, which is where it belongs.

This fixes case where interface is NULL when parsing of report
descriptor fails.

LKML-Reference: <20100213135720.603e5f64@neptune.home>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1007,9 +1007,6 @@ static int usbhid_start(struct hid_devic
 
 	spin_lock_init(&usbhid->lock);
 
-	usbhid->intf = intf;
-	usbhid->ifnum = interface->desc.bInterfaceNumber;
-
 	usbhid->urbctrl = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbhid->urbctrl) {
 		ret = -ENOMEM;
@@ -1180,6 +1177,8 @@ static int usbhid_probe(struct usb_inter
 
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
+	usbhid->intf = intf;
+	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
 	ret = hid_add_device(hid);
 	if (ret) {


