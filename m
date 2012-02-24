Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2BXNqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:46:40 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43949 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755195Ab2BXNqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:37 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] dec/tulip/de4x5: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:45:55 +0100
Message-Id: <1330091162-8141-5-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091197;6c473491;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/dec/tulip/de4x5.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 9358340..18b106c 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -5234,11 +5234,7 @@ de4x5_dbg_open(struct net_device *dev)
 
     if (de4x5_debug & DEBUG_OPEN) {
 	printk("%s: de4x5 opening with irq %d\n",dev->name,dev->irq);
-	printk("\tphysical address: ");
-	for (i=0;i<6;i++) {
-	    printk("%2.2x:",(short)dev->dev_addr[i]);
-	}
-	printk("\n");
+	printk("\tphysical address: %pM\n", dev->dev_addr);
 	printk("Descriptor head addresses:\n");
 	printk("\t0x%8.8lx  0x%8.8lx\n",(u_long)lp->rx_ring,(u_long)lp->tx_ring);
 	printk("Descriptor addresses:\nRX: ");
-- 
1.7.8.3

