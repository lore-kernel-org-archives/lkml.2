Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2AJKM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:12:26 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35991 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab2AJKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.072
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Rick Jones <rick.jones2@hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/21] bcm63xx_enet: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:24 +0100
Message-Id: <1326189567-21663-19-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index a11a8ad..0e871b0 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1727,7 +1727,7 @@ static int __devinit bcm_enet_probe(struct platform_device *pdev)
 		bus->priv = priv;
 		bus->read = bcm_enet_mdio_read_phylib;
 		bus->write = bcm_enet_mdio_write_phylib;
-		sprintf(bus->id, "%d", priv->mac_id);
+		sprintf(bus->id, "%s-%d", pdev->name, priv->mac_id);
 
 		/* only probe bus where we think the PHY is, because
 		 * the mdio read operation return 0 instead of 0xffff
-- 
1.7.5.4

