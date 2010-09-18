Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0IRTC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:27 -0400
Received: from kroah.org ([198.145.64.141]:51243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0IRTBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:30 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185955.568489780@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philippe Corbes <philippe.corbes@gmail.com>
Subject: [032/123] USB: cdc-acm: Add pseudo modem without AT command capabilities
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-cdc-acm-add-pseudo-modem-without-at-command-capabilities.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
@@ -1599,6 +1599,10 @@ static struct usb_device_id acm_ids[] =
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 
+	/* control interfaces without any protocol set */
+	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
+		USB_CDC_PROTO_NONE) },
+
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_ACM_PROTO_AT_V25TER) },


