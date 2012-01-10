Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2AJKLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:11:14 -0500
Received: from zmc.proxad.net ([212.27.53.206]:36000 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab2AJKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.07
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/21] ixp4xx-eth: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:23 +0100
Message-Id: <1326189567-21663-18-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index f45c85a..72a854f 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -529,7 +529,7 @@ static int ixp4xx_mdio_register(void)
 	mdio_bus->name = "IXP4xx MII Bus";
 	mdio_bus->read = &ixp4xx_mdio_read;
 	mdio_bus->write = &ixp4xx_mdio_write;
-	strcpy(mdio_bus->id, "0");
+	snprintf(mdio_bus->id, MII_BUS_ID_SIZE, "ixp4xx-eth-0");
 
 	if ((err = mdiobus_register(mdio_bus)))
 		mdiobus_free(mdio_bus);
-- 
1.7.5.4

