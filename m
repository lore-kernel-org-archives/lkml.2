Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2AJKKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:10:47 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35994 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab2AJKJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:41 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.052
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Crispin <blogic@openwrt.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/21] lantiq_etop: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:14 +0100
Message-Id: <1326189567-21663-9-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/lantiq_etop.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 0b3567a..85e2c6c 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -98,6 +98,7 @@ struct ltq_etop_chan {
 
 struct ltq_etop_priv {
 	struct net_device *netdev;
+	struct platform_device *pdev;
 	struct ltq_eth_data *pldata;
 	struct resource *res;
 
@@ -436,7 +437,8 @@ ltq_etop_mdio_init(struct net_device *dev)
 	priv->mii_bus->read = ltq_etop_mdio_rd;
 	priv->mii_bus->write = ltq_etop_mdio_wr;
 	priv->mii_bus->name = "ltq_mii";
-	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%x", 0);
+	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		priv->pdev->name, priv->pdev->id);
 	priv->mii_bus->irq = kmalloc(sizeof(int) * PHY_MAX_ADDR, GFP_KERNEL);
 	if (!priv->mii_bus->irq) {
 		err = -ENOMEM;
@@ -734,6 +736,7 @@ ltq_etop_probe(struct platform_device *pdev)
 	dev->ethtool_ops = &ltq_etop_ethtool_ops;
 	priv = netdev_priv(dev);
 	priv->res = res;
+	priv->pdev = pdev;
 	priv->pldata = dev_get_platdata(&pdev->dev);
 	priv->netdev = dev;
 	spin_lock_init(&priv->lock);
-- 
1.7.5.4

