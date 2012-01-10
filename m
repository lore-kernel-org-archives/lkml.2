Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2AJKLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:11:37 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35998 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab2AJKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.05
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Xiao Jiang <jgq516@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/21] fec: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:13 +0100
Message-Id: <1326189567-21663-8-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/freescale/fec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index 20c2e3f..c6aa641 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -1077,7 +1077,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->read = fec_enet_mdio_read;
 	fep->mii_bus->write = fec_enet_mdio_write;
 	fep->mii_bus->reset = fec_enet_mdio_reset;
-	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%x", fep->dev_id + 1);
+	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		pdev->name, fep->dev_id + 1);
 	fep->mii_bus->priv = fep;
 	fep->mii_bus->parent = &pdev->dev;
 
-- 
1.7.5.4

