Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0GNSD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:03:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60272 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab0GNSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Tbt7aHfx8FxAeQ/O+aE2ShMUc7/dLPldFMZotHNc2Bp1vnum3+dBX7Ie1NnNpiIWn7
         X0jPyDfmxYjTMDZClQDOfBK8S6thZBTyN0W8bXmmTQyNfTHqW9H4FwC7cNXF+UqH3PQv
         L24Po1Es4chm4u1ZVAnx87Z1y3h9kX15uy1Xg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Grant Grundler <grundler@parisc-linux.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Jiri Pirko <jpirko@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 05/11] tulip: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:02:47 +0400
Message-Id: <1279130568-10857-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/tulip/tulip_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 03e96b9..14e5312 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -596,10 +596,10 @@ static void tulip_tx_timeout(struct net_device *dev)
 					pr_cont(" %02x", buf[j]);
 			pr_cont(" j=%d\n", j);
 		}
-		printk(KERN_DEBUG "  Rx ring %08x: ", (int)tp->rx_ring);
+		printk(KERN_DEBUG "  Rx ring %p: ", tp->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
 			pr_cont(" %08x", (unsigned int)tp->rx_ring[i].status);
-		printk(KERN_DEBUG "  Tx ring %08x: ", (int)tp->tx_ring);
+		printk(KERN_DEBUG "  Tx ring %p: ", tp->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
 			pr_cont(" %08x", (unsigned int)tp->tx_ring[i].status);
 		pr_cont("\n");
-- 
1.7.0.4

