Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1JTVN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:13:57 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:35680
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1JTVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:13:25 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        "David S. Miller" <davem@conan.davemloft.net>,
        Mike Frysinger <vapier@gentoo.org>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [RFC PATCH 08/17] drivers/net/bfin_mac: Don't unnecessarily reset the PHY
Date: Thu, 20 Oct 2011 17:00:15 -0400
Message-Id: <1319144425-15547-9-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PHY is already reset during driver probing, and this manual reset
afterwards will wipe out board-specific PHY fixups and driver-specific
phy->drv->config_init() register tweaks.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 drivers/net/bfin_mac.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 6c019e1..1427ec3 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -1402,7 +1402,6 @@ static int bfin_mac_open(struct net_device *dev)
 		return ret;
 
 	phy_start(lp->phydev);
-	phy_write(lp->phydev, MII_BMCR, BMCR_RESET);
 	setup_system_regs(dev);
 	setup_mac_addr(dev->dev_addr);
 
-- 
1.7.2.5

