Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2AJKNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:13:23 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35990 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab2AJKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.042
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Wan ZongShun <mcuos.com@gmail.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/21] sb1250: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:10 +0100
Message-Id: <1326189567-21663-5-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/broadcom/sb1250-mac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index 8fa7abc..084904c 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -2259,7 +2259,8 @@ static int sbmac_init(struct platform_device *pldev, long long base)
 	}
 
 	sc->mii_bus->name = sbmac_mdio_string;
-	snprintf(sc->mii_bus->id, MII_BUS_ID_SIZE, "%x", idx);
+	snprintf(sc->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		pldev->name, idx);
 	sc->mii_bus->priv = sc;
 	sc->mii_bus->read = sbmac_mii_read;
 	sc->mii_bus->write = sbmac_mii_write;
-- 
1.7.5.4

