Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2EIGXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:23:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38911 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab2EIFxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:15 -0400
Message-Id: <20120509055041.030028768@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephane Fillod <fillods@users.sf.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 081/167] [PATCH 21/26] net: usb: smsc75xx: fix mtu
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Fillod <fillods@users.sf.net>

[ Upstream commit a99ff7d0123b19ecad3b589480b6542716ab6b52 ]

Make smsc75xx recalculate the hard_mtu after adjusting the
hard_header_len.

Without this, usbnet adjusts the MTU down to 1492 bytes, and the host is
unable to receive standard 1500-byte frames from the device.

Inspired by same fix on cdc_eem 78fb72f7936c01d5b426c03a691eca082b03f2b9.

Tested on ARM/Omap3 with EVB-LAN7500-LC.

Signed-off-by: Stephane Fillod <fillods@users.sf.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/smsc75xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index a5b9b12..7bd219b 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1050,6 +1050,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->ethtool_ops = &smsc75xx_ethtool_ops;
 	dev->net->flags |= IFF_MULTICAST;
 	dev->net->hard_header_len += SMSC75XX_TX_OVERHEAD;
+	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 	return 0;
 }
 
-- 
1.7.10



