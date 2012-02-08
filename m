Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab2BHVU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:20:56 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34127 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757686Ab2BHVUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:20:53 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Daniele Venzano <venza@brownhat.org>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/50] sis900: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:31 +0100
Message-Id: <1328735457-29986-25-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736053;e0767fe9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/sis/sis900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index c8efc70..cbd0343 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -527,7 +527,7 @@ static int __devinit sis900_probe(struct pci_dev *pci_dev,
 		ret = sis900_get_mac_addr(pci_dev, net_dev);
 
 	if (!ret || !is_valid_ether_addr(net_dev->dev_addr)) {
-		random_ether_addr(net_dev->dev_addr);
+		dev_hw_addr_random(net_dev, net_dev->dev_addr);
 		printk(KERN_WARNING "%s: Unreadable or invalid MAC address,"
 				"using random generated one\n", dev_name);
 	}
-- 
1.7.7.3

