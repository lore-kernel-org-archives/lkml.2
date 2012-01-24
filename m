Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2AXJ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:26:59 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:65120 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab2AXJ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:26:55 -0500
Date: Tue, 24 Jan 2012 10:26:48 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, peppe.cavallaro@st.com, florian@openwrt.org
Subject: stmmac: fix phy naming inconsistency
Message-ID: <20120124092648.GA26380@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "db8857b stmmac: use an unique MDIO bus name" my
device stopped being probed because two different names were being
used in different places. This fixes the inconsistency.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Florian Fainelli <florian@openwrt.org>
---

Before the commit, the phy was identified like this and stuff worked:

     PHY ID 20005c90 at 1 IRQ 0 (506:01) active

After that commit, I get 

     PHY ID 20005c90 at 1 IRQ 0 (STMMAC MII Bus-1:01) active
     PHY stmmac-1:01 not found

In one place, "stmmac" is a static string, on the other the commit
used the name field of the bus that was "STMMAC MII Bus", so I changed
this older string to be nicer -- without spaces.

Maybe the name is available where "stmmac" is spelled out, but I
didn't check.

Now it works for me:

    eth1: PHY ID 20005c90 at 1 IRQ 0 (stmmac-1:01) active
    PHY: stmmac-1:01 - Link is Up - 100/Full


 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 6e712c5..819606e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -154,7 +154,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	else
 		irqlist = priv->mii_irq;
 
-	new_bus->name = "STMMAC MII Bus";
+	new_bus->name = "stmmac";
 	new_bus->read = &stmmac_mdio_read;
 	new_bus->write = &stmmac_mdio_write;
 	new_bus->reset = &stmmac_mdio_reset;
-- 
1.7.7.2
