Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab2DKXOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:14:49 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40940 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab2DKXOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:14:45 -0400
Message-Id: <20120411231019.210179470@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.name>,
        Rabin Vincent <rabin@rab.in>, "David S. Miller" <davem@davemloft.net>
Subject: [ 06/78] net: usb: cdc_eem: fix mtu
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rabin Vincent <rabin@rab.in>

[ Upstream commit 78fb72f7936c01d5b426c03a691eca082b03f2b9 ]

Make CDC EEM recalculate the hard_mtu after adjusting the
hard_header_len.

Without this, usbnet adjusts the MTU down to 1494 bytes, and the host is
unable to receive standard 1500-byte frames from the device.

Tested with the Linux USB Ethernet gadget.

Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_eem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -93,6 +93,7 @@ static int eem_bind(struct usbnet *dev,
 	/* no jumbogram (16K) support for now */
 
 	dev->net->hard_header_len += EEM_HEAD + ETH_FCS_LEN;
+	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 
 	return 0;
 }


