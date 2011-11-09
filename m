Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116Ab1KJD3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935071Ab1KJD3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.864801850@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Vasut <marek.vasut@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [172/262] ASIX: Simplify condition in rx_fixup()
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit bc466e678d0a98f445bf3f9c76fedf18e7dcc6b0 upstream.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -314,10 +314,9 @@ static int asix_rx_fixup(struct usbnet *
 	skb_pull(skb, 4);
 
 	while (skb->len > 0) {
-		if ((short)(header & 0x0000ffff) !=
-		    ~((short)((header & 0xffff0000) >> 16))) {
+		if ((header & 0xffff) != ((~header >> 16) & 0xffff))
 			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
-		}
+
 		/* get the packet length */
 		size = (u16) (header & 0x0000ffff);
 


