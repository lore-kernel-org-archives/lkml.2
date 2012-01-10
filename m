Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2AJKK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:10:28 -0500
Received: from zmc.proxad.net ([212.27.53.206]:36002 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab2AJKJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:41 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.047
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wan ZongShun <mcuos.com@gmail.com>, Rick Jones <rick.jones2@hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/21] dnet: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:12 +0100
Message-Id: <1326189567-21663-7-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/dnet.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index ce88c0f..925c9ba 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -325,7 +325,8 @@ static int dnet_mii_init(struct dnet *bp)
 	bp->mii_bus->write = &dnet_mdio_write;
 	bp->mii_bus->reset = &dnet_mdio_reset;
 
-	snprintf(bp->mii_bus->id, MII_BUS_ID_SIZE, "%x", 0);
+	snprintf(bp->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		bp->pdev->name, bp->pdev->id);
 
 	bp->mii_bus->priv = bp;
 
-- 
1.7.5.4

