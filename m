Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2AJKM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:12:28 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35996 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab2AJKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.057
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wan ZongShun <mcuos.com@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/21] pxa168-eth: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:16 +0100
Message-Id: <1326189567-21663-11-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/marvell/pxa168_eth.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 5ec409e..953ba58 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1552,7 +1552,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	pep->smi_bus->name = "pxa168_eth smi";
 	pep->smi_bus->read = pxa168_smi_read;
 	pep->smi_bus->write = pxa168_smi_write;
-	snprintf(pep->smi_bus->id, MII_BUS_ID_SIZE, "%d", pdev->id);
+	snprintf(pep->smi_bus->id, MII_BUS_ID_SIZE, "%s-%d",
+		pdev->name, pdev->id);
 	pep->smi_bus->parent = &pdev->dev;
 	pep->smi_bus->phy_mask = 0xffffffff;
 	err = mdiobus_register(pep->smi_bus);
-- 
1.7.5.4

