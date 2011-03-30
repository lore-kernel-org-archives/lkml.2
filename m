Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276Ab1C3VPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:15:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:45379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291Ab1C3VKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279263"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: cebbert@redhat.com, t.sailer@alumni.ethz.ch, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [259/275] USB: misc: uss720.c: add another vendor/product ID
Message-Id: <20110330210826.631C13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
In 2.6.35.10:

[  122.146074] usb 2-1: new full speed USB device using uhci_hcd and address 2
[  122.325102] usb 2-1: New USB device found, idVendor=050d, idProduct=0002
[  122.325110] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  122.325117] usb 2-1: Product: IEEE-1284 Controller
[  122.325121] usb 2-1: Manufacturer: Belk USB Printing Support
[  123.531167] usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid
0x050D pid 0x0002
[  123.531208] usbcore: registered new interface driver usblp

In 2.6.35.11:

[ 8046.227051] usb 2-1: new full speed USB device using uhci_hcd and address 6
[ 8046.408083] usb 2-1: New USB device found, idVendor=050d, idProduct=0002
[ 8046.408088] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 8046.408092] usb 2-1: Product: IEEE-1284 Controller
[ 8046.408094] usb 2-1: Manufacturer: Belk USB Printing Support
[ 8047.552140] get_1284_register timeout
[ 8047.554102] uss720: async_complete: urb error -104
[repeats]
[ 8047.556111] uss720: async_complete: urb error -32
[sequence repeats]
[unplug connector]
[ 8485.688067] parport0: fix this legacy no-device port driver!
[ 8485.688427] uss720: async_complete: urb error -32

Blacklisting the uss720 driver fixes the problem.


>From 0a67b7cf26d73ed1dbea7e99d63673b5c4aa479e Mon Sep 17 00:00:00 2001
From: Thomas Sailer <t.sailer@alumni.ethz.ch>
Date: Tue, 14 Dec 2010 16:04:05 +0100
Subject: [PATCH] USB: misc: uss720.c: add another vendor/product ID

commit ecc1624a2fff45780959efbcb73ace18fdb3c58d upstream.

Fabio Battaglia report that he has another cable that works with this
driver, so this patch adds its vendor/product ID.

Signed-off-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/uss720.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/usb/misc/uss720.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/misc/uss720.c	2011-03-29 23:08:16.511201441 -0700
+++ linux-2.6.35.y/drivers/usb/misc/uss720.c	2011-03-29 23:18:25.138628187 -0700
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005, 2010
+ *	Copyright (C) 1999, 2005
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -775,8 +775,6 @@
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
-	{ USB_DEVICE(0x1293, 0x0002) },
-	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 
