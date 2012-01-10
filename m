Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2AJKJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:09:42 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35983 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab2AJKJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:38 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.067
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/21] stmmac: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:20 +0100
Message-Id: <1326189567-21663-15-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3738b47..f884d67 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -307,7 +307,7 @@ static int stmmac_init_phy(struct net_device *dev)
 	priv->speed = 0;
 	priv->oldduplex = -1;
 
-	snprintf(bus_id, MII_BUS_ID_SIZE, "%x", priv->plat->bus_id);
+	snprintf(bus_id, MII_BUS_ID_SIZE, "stmmac-%x", priv->plat->bus_id);
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT, bus_id,
 		 priv->plat->phy_addr);
 	pr_debug("stmmac_init_phy:  trying to attach to %s\n", phy_id);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 51f4412..da4a104 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -158,7 +158,8 @@ int stmmac_mdio_register(struct net_device *ndev)
 	new_bus->read = &stmmac_mdio_read;
 	new_bus->write = &stmmac_mdio_write;
 	new_bus->reset = &stmmac_mdio_reset;
-	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", mdio_bus_data->bus_id);
+	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		new_bus->name, mdio_bus_data->bus_id);
 	new_bus->priv = ndev;
 	new_bus->irq = irqlist;
 	new_bus->phy_mask = mdio_bus_data->phy_mask;
-- 
1.7.5.4

