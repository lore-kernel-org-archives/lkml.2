Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2DSIDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:03:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17048 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2DSIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:03:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6685"; a="183042507"
X-IronPort-AV: E=Sophos;i="4.75,445,1330934400"; 
   d="scan'208";a="200015008"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 11/11] atl1c: remove MDIO_REG_ADDR_MASK in atl1c_mdio_read/write
Date: Thu, 19 Apr 2012 16:01:31 +0800
Message-ID: <1334822491-30129-12-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334822491-30129-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334822491-30129-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MDIO_REG_ADDR_MASK is already applied in function
atl1c_write_phy_reg and atl1c_read_phy_reg

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index e671367..df10637 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -575,7 +575,7 @@ static int atl1c_mdio_read(struct net_device *netdev, int phy_id, int reg_num)
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	u16 result;
 
-	atl1c_read_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, &result);
+	atl1c_read_phy_reg(&adapter->hw, reg_num, &result);
 	return result;
 }
 
@@ -584,7 +584,7 @@ static void atl1c_mdio_write(struct net_device *netdev, int phy_id,
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
-	atl1c_write_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, val);
+	atl1c_write_phy_reg(&adapter->hw, reg_num, val);
 }
 
 /*
-- 
1.7.7

