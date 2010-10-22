Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab0JVSmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:42:43 -0400
Received: from kroah.org ([198.145.64.141]:46007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935Ab0JVSlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:40 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:33 2010
Message-Id: <20101022184033.749005334@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Fertser <fercerpav@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [14/17] b44: fix carrier detection on bind
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Fertser <fercerpav@gmail.com>

commit bcf64aa379fcadd074449cbf0c049da70071b06f upstream.

For carrier detection to work properly when binding the driver with a cable
unplugged, netif_carrier_off() should be called after register_netdev(),
not before.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/b44.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2164,8 +2164,6 @@ static int __devinit b44_init_one(struct
 	dev->irq = sdev->irq;
 	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
 
-	netif_carrier_off(dev);
-
 	err = ssb_bus_powerup(sdev->bus, 0);
 	if (err) {
 		dev_err(sdev->dev,
@@ -2205,6 +2203,8 @@ static int __devinit b44_init_one(struct
 		goto err_out_powerdown;
 	}
 
+	netif_carrier_off(dev);
+
 	ssb_set_drvdata(sdev, dev);
 
 	/* Chip reset provides power to the b44 MAC & PCI cores, which


