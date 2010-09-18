Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0IRTbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:31:52 -0400
Received: from kroah.org ([198.145.64.141]:43393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab0IRTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:12 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.520378479@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philippe Corbes <philippe.corbes@gmail.com>
Subject: [049/129] USB: cdc-acm: Add pseudo modem without AT command capabilities
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Philippe Corbes <philippe.corbes@gmail.com>

commit 5b239f0aebd4dd6f85b13decf5e18e86e35d57f0 upstream.

cdc-acm.c : Manage pseudo-modem without AT commands capabilities
  Enable to drive electronic simple gadgets based on microcontrolers.
  The Interface descriptor is like this:
    bInterfaceClass         2 Communications
    bInterfaceSubClass      2 Abstract (modem)
    bInterfaceProtocol      0 None

Signed-off-by: Philippe Corbes <philippe.corbes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1621,6 +1621,10 @@ static const struct usb_device_id acm_id
 	.driver_info = NOT_A_MODEM,
        	},
 
+	/* control interfaces without any protocol set */
+	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
+		USB_CDC_PROTO_NONE) },
+
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_ACM_PROTO_AT_V25TER) },


