Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008Ab2CAQzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:55:19 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51647 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758274Ab2CAQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:53:11 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, Florian Fainelli <florian@openwrt.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] bcm63xx_enet: use dev_set_mac_address() instead of bcm_enet_set_mac_address()
Date: Thu,  1 Mar 2012 17:52:23 +0100
Message-Id: <1330620747-4047-4-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330620747-4047-1-git-send-email-danny.kukawka@bisect.de>
References: <1330620747-4047-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330620791;669231a1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_set_mac_address() instead of bcm_enet_set_mac_address() directly
to get validation checks for free.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Florian Fainelli <ffainelli@freebox.fr>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index c7ca7ec..28184a8 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -858,7 +858,7 @@ static int bcm_enet_open(struct net_device *dev)
 
 	/* write device mac address */
 	memcpy(addr.sa_data, dev->dev_addr, ETH_ALEN);
-	bcm_enet_set_mac_address(dev, &addr);
+	dev_set_mac_address(dev, &addr);
 
 	/* allocate rx dma ring */
 	size = priv->rx_ring_size * sizeof(struct bcm_enet_desc);
-- 
1.7.8.3

