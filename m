Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab2BHVVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:04 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34162 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757767Ab2BHVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:03 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 19/50] macsonic: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:26 +0100
Message-Id: <1328735457-29986-20-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736062;c7fc57bb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/natsemi/macsonic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index f1b8556..c3819dc 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -307,7 +307,7 @@ static void __devinit mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 
 	printk(KERN_WARNING "macsonic: MAC address in CAM entry 15 "
 	                    "seems invalid, will use a random MAC\n");
-	random_ether_addr(dev->dev_addr);
+	dev_hw_addr_random(dev, dev->dev_addr);
 }
 
 static int __devinit mac_onboard_sonic_probe(struct net_device *dev)
-- 
1.7.7.3

