Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2AJKKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:10:46 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35995 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178Ab2AJKJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:09:41 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.065
From: Florian Fainelli <florian@openwrt.org>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/21] smsc911x: use an unique MDIO bus name.
Date: Tue, 10 Jan 2012 10:59:19 +0100
Message-Id: <1326189567-21663-14-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326189567-21663-1-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/smsc/smsc911x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 9d0b8ce..24d2df0 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1044,7 +1044,8 @@ static int __devinit smsc911x_mii_init(struct platform_device *pdev,
 	}
 
 	pdata->mii_bus->name = SMSC_MDIONAME;
-	snprintf(pdata->mii_bus->id, MII_BUS_ID_SIZE, "%x", pdev->id);
+	snprintf(pdata->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		pdev->name, pdev->id);
 	pdata->mii_bus->priv = pdata;
 	pdata->mii_bus->read = smsc911x_mii_read;
 	pdata->mii_bus->write = smsc911x_mii_write;
-- 
1.7.5.4

