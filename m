Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2BHVWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:22:30 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34324 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932281Ab2BHVWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:22:13 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 46/50] wan: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:53 +0100
Message-Id: <1328735457-29986-47-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736133;5f2a4159;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/wan/hdlc_fr.c      |    2 +-
 drivers/net/wan/hdlc_raw_eth.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index eb20281..579664c 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1087,7 +1087,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	}
 
 	if (type == ARPHRD_ETHER)
-		random_ether_addr(dev->dev_addr);
+		dev_hw_addr_random(dev, dev->dev_addr);
 	else {
 		*(__be16*)dev->dev_addr = htons(dlci);
 		dlci_to_q922(dev->broadcast, dlci);
diff --git a/drivers/net/wan/hdlc_raw_eth.c b/drivers/net/wan/hdlc_raw_eth.c
index 05c9b0b..0962a42 100644
--- a/drivers/net/wan/hdlc_raw_eth.c
+++ b/drivers/net/wan/hdlc_raw_eth.c
@@ -101,7 +101,7 @@ static int raw_eth_ioctl(struct net_device *dev, struct ifreq *ifr)
 		old_qlen = dev->tx_queue_len;
 		ether_setup(dev);
 		dev->tx_queue_len = old_qlen;
-		random_ether_addr(dev->dev_addr);
+		dev_hw_addr_random(dev, dev->dev_addr);
 		netif_dormant_off(dev);
 		return 0;
 	}
-- 
1.7.7.3

