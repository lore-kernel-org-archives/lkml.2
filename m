Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0LTF2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 00:28:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42092 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab0LTF2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 00:28:23 -0500
Date: Mon, 20 Dec 2010 16:28:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20101220162811.8c8d8d76.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/gadget/composite.c between commit
dbb442b85a1d82f91cfe0524c4f9b3a5196a10ca ("Revert "USB: gadget: Allow
function access to device ID data during bind()"") from the usb.current
tree and commit 78bff3c65df33da47e93736bd8847b694084e5a9 ("USB: gadget:
composite: Typo fix") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/composite.c
index 8572dad,21dc0da..0000000
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@@ -1118,15 -1126,7 +1118,15 @@@ static int composite_bind(struct usb_ga
  	cdev->desc = *composite->dev;
  	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
  
 +	/* standardized runtime overrides for device ID data */
 +	if (idVendor)
 +		cdev->desc.idVendor = cpu_to_le16(idVendor);
 +	if (idProduct)
 +		cdev->desc.idProduct = cpu_to_le16(idProduct);
 +	if (bcdDevice)
 +		cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
 +
- 	/* stirng overrides */
+ 	/* string overrides */
  	if (iManufacturer || !cdev->desc.iManufacturer) {
  		if (!iManufacturer && !composite->iManufacturer &&
  		    !*composite_manufacturer)
