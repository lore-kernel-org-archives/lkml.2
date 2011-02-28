Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1B1Qmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:42:49 -0500
Received: from kroah.org ([198.145.64.141]:48200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab1B1QiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:11 2011
Message-Id: <20110228162410.917297520@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [52/68] USB: add quirks entry for Keytouch QWERTY Panel
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3c18e30f87ac5466bddbb05cf955605efd7db025 upstream.

This patch (as1448) adds a quirks entry for the Keytouch QWERTY Panel
firmware, used in the IEC 60945 keyboard.  This device crashes during
enumeration when the computer asks for its configuration string
descriptor.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: kholis <nur.kholis.majid@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -68,6 +68,10 @@ static const struct usb_device_id usb_qu
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Keytouch QWERTY Panel keyboard */
+	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 


