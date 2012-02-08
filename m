Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2BHVWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:22:06 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34290 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab2BHVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:59 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        James Chapman <jchapman@katalix.com>
Subject: [PATCH 41/50] l2tp_eth: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:48 +0100
Message-Id: <1328735457-29986-42-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736119;aefed04b;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/l2tp/l2tp_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index d2726a7..fa91e4e 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -64,7 +64,7 @@ static int l2tp_eth_dev_init(struct net_device *dev)
 	struct l2tp_eth *priv = netdev_priv(dev);
 
 	priv->dev = dev;
-	random_ether_addr(dev->dev_addr);
+	dev_hw_addr_random(dev, dev->dev_addr);
 	memset(&dev->broadcast[0], 0xff, 6);
 
 	return 0;
-- 
1.7.7.3

