Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2BHVVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:21 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34185 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826Ab2BHVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:19 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        Joe Perches <joe@perches.com>, Jason Wang <jasowang@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 45/50] tun: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:52 +0100
Message-Id: <1328735457-29986-46-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736079;41815dff;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/tun.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 93c5d72..ace3f9c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -531,7 +531,7 @@ static void tun_net_init(struct net_device *dev)
 		ether_setup(dev);
 		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
-		random_ether_addr(dev->dev_addr);
+		dev_hw_addr_random(dev, dev->dev_addr);
 
 		dev->tx_queue_len = TUN_READQ_SIZE;  /* We prefer our own queue length */
 		break;
-- 
1.7.7.3

