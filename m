Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423257Ab2JaQFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:05:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:30631 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423237Ab2JaQFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:05:30 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <havard@skinnemoen.net>
CC: <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <David.Laight@ACULAB.COM>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v4 04/10] net/macb: remove macb_get_drvinfo()
Date: Wed, 31 Oct 2012 17:04:53 +0100
Message-ID: <4a584a0782c6d6625254d8339e2554f9646ecc16.1351690694.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1351690694.git.nicolas.ferre@atmel.com>
References: <cover.1351690694.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has little meaning so remove it altogether and
let ethtool core fill in the fields automatically.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>
Tested-by: Joachim Eastwood <manabian@gmail.com>
---
 drivers/net/ethernet/cadence/macb.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index b161d73..4db52f3 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1225,20 +1225,9 @@ static int macb_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 	return phy_ethtool_sset(phydev, cmd);
 }
 
-static void macb_get_drvinfo(struct net_device *dev,
-			     struct ethtool_drvinfo *info)
-{
-	struct macb *bp = netdev_priv(dev);
-
-	strcpy(info->driver, bp->pdev->dev.driver->name);
-	strcpy(info->version, "$Revision: 1.14 $");
-	strcpy(info->bus_info, dev_name(&bp->pdev->dev));
-}
-
 const struct ethtool_ops macb_ethtool_ops = {
 	.get_settings		= macb_get_settings,
 	.set_settings		= macb_set_settings,
-	.get_drvinfo		= macb_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_ts_info		= ethtool_op_get_ts_info,
 };
-- 
1.8.0

