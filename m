Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2AJKNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:13:25 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35993 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab2AJKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.055
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/21] mv643xx-eth: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:15 +0100
Message-Id: <1326189567-21663-10-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index e87847e..f14122c 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2612,7 +2612,8 @@ static int mv643xx_eth_shared_probe(struct platform_device *pdev)
 		msp->smi_bus->name = "mv643xx_eth smi";
 		msp->smi_bus->read = smi_bus_read;
 		msp->smi_bus->write = smi_bus_write,
-		snprintf(msp->smi_bus->id, MII_BUS_ID_SIZE, "%d", pdev->id);
+		snprintf(msp->smi_bus->id, MII_BUS_ID_SIZE, "%s-%d",
+			pdev->name, pdev->id);
 		msp->smi_bus->parent = &pdev->dev;
 		msp->smi_bus->phy_mask = 0xffffffff;
 		if (mdiobus_register(msp->smi_bus) < 0)
-- 
1.7.5.4

