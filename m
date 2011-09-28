Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1I1Xel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:34:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1I1Wh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.241160768@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [019/244] USB option driver K3765/K4505 avoid CDC_DATA interface
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Bird <ajb@spheresystems.co.uk>

commit 6118514e8749105334f46ccec6faf9a439be6cf9 upstream.

Currently the Option driver avoids binding interface 1 on Huawei K3765
and K4505 broadband modems as it should be handled by the cdc_ether
driver instead. This patch ensures we don't bind the interface 2
on those devices as that is CDC_DATA.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1235,7 +1235,8 @@ static int option_probe(struct usb_seria
 		(serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K3765 ||
 			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4505 ||
 			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4605) &&
-		serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
+		(serial->interface->cur_altsetting->desc.bInterfaceNumber == 1 ||
+			serial->interface->cur_altsetting->desc.bInterfaceNumber == 2))
 		return -ENODEV;
 
 	/* Don't bind network interface on Samsung GT-B3730, it is handled by a separate module */


