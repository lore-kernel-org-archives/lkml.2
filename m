Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0HXX1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:27:21 -0400
Received: from kroah.org ([198.145.64.141]:40635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111Ab0HXW7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:50 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:19 2010
Message-Id: <20100824224219.115294999@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [82/91] USB: add device IDs for igotu to navman
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ross Burton <ross@linux.intel.com>

commit 0eee6a2b2a52e17066a572d30ad2805d3ebc7508 upstream.

I recently bought a i-gotU USB GPS, and whilst hunting around for linux
support discovered this post by you back in 2009:

http://kerneltrap.org/mailarchive/linux-usb/2009/3/12/5148644

>Try the navman driver instead.  You can either add the device id to the
> driver and rebuild it, or do this before you plug the device in:
> 	modprobe navman
> 	echo -n "0x0df7 0x0900" > /sys/bus/usb-serial/drivers/navman/new_id
>
> and then plug your device in and see if that works.

I can confirm that the navman driver works with the right device IDs on
my i-gotU GT-600, which has the same device IDs.  Attached is a patch
adding the IDs.

From: Ross Burton <ross@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/navman.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -25,6 +25,7 @@ static int debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0a99, 0x0001) },	/* Talon Technology device */
+	{ USB_DEVICE(0x0df7, 0x0900) },	/* Mobile Action i-gotU */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


