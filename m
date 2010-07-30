Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab0G3Ryu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:54:50 -0400
Received: from kroah.org ([198.145.64.141]:57844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759727Ab0G3RyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.767584357@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [013/205] usbnet: Set parent device early for netdev_printk()
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ben Hutchings <ben@decadent.org.uk>

[ Upsteam commit 0dacca73a3ddefa6cb8a7e0282f938e01faa1a64 ]

netdev_printk() follows the net_device's parent device pointer, so
we must set that earlier than we previously did.

Reported-by: Luís Picciochi Oliveira <pitxyoki@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/usbnet.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1290,6 +1290,9 @@ usbnet_probe (struct usb_interface *udev
 		goto out;
 	}
 
+	/* netdev_printk() needs this so do it as early as possible */
+	SET_NETDEV_DEV(net, &udev->dev);
+
 	dev = netdev_priv(net);
 	dev->udev = xdev;
 	dev->intf = udev;
@@ -1374,8 +1377,6 @@ usbnet_probe (struct usb_interface *udev
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
 
-	SET_NETDEV_DEV(net, &udev->dev);
-
 	if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 		SET_NETDEV_DEVTYPE(net, &wlan_type);
 	if ((dev->driver_info->flags & FLAG_WWAN) != 0)


