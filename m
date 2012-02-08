Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2BHVLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:11:21 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:36443 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300Ab2BHVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:11:15 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: netdev@vger.kernel.org
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 02/50] smsc95xx: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:09 +0100
Message-Id: <1328735457-29986-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328735475;cac68943;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/usb/smsc95xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index d45520e..3a28e95 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -614,7 +614,7 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
 	}
 
 	/* no eeprom, or eeprom values are invalid. generate random MAC */
-	random_ether_addr(dev->net->dev_addr);
+	dev_hw_addr_random(dev->net , dev->net->dev_addr);
 	netif_dbg(dev, ifup, dev->net, "MAC address set to random_ether_addr\n");
 }
 
-- 
1.7.7.3

