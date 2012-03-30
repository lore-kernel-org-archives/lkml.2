Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946Ab2C3WEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:04:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965499Ab2C3VQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:44 -0400
Message-Id: <20120330194826.156260703@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 003/175] USB: option: make interface blacklist work again
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 963940cf472d76eca2d36296e461202cc6997352 upstream.

commit 0d905fd "USB: option: convert Huawei K3765, K4505, K4605
reservered interface to blacklist" accidentally ANDed two
blacklist tests by leaving out a return.  This was not noticed
because the two consecutive bracketless if statements made it
syntactically correct.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1373,6 +1373,7 @@ static int option_probe(struct usb_seria
 		serial->interface->cur_altsetting->desc.bInterfaceNumber,
 		OPTION_BLACKLIST_RESERVED_IF,
 		(const struct option_blacklist_info *) id->driver_info))
+		return -ENODEV;
 
 	/* Don't bind network interface on Samsung GT-B3730, it is handled by a separate module */
 	if (serial->dev->descriptor.idVendor == SAMSUNG_VENDOR_ID &&


