Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935539Ab2C3VJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:09:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935530Ab2C3VJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:48 -0400
Message-Id: <20120330194837.510408075@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Orjan Friberg <of@flatfrog.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 021/149] USB: gadget: Make g_hid device class conform to spec.
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orjan Friberg <of@flatfrog.com>

commit 33d2832ab0149a26418d360af3c444969a63fb28 upstream.

HID devices should specify this in their interface descriptors, not in the
device descriptor. This fixes a "missing hardware id" bug under Windows 7 with
a VIA VL800 (3.0) controller.

Signed-off-by: Orjan Friberg <of@flatfrog.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/hid.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -60,9 +60,9 @@ static struct usb_device_descriptor devi
 	/* .bDeviceClass =		USB_CLASS_COMM, */
 	/* .bDeviceSubClass =	0, */
 	/* .bDeviceProtocol =	0, */
-	.bDeviceClass =		0xEF,
-	.bDeviceSubClass =	2,
-	.bDeviceProtocol =	1,
+	.bDeviceClass =		USB_CLASS_PER_INTERFACE,
+	.bDeviceSubClass =	0,
+	.bDeviceProtocol =	0,
 	/* .bMaxPacketSize0 = f(hardware) */
 
 	/* Vendor and product id can be overridden by module parameters.  */


