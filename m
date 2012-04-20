Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2DTGR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:17:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53904 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2DTGRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:17:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="183391899"
X-IronPort-AV: E=Sophos;i="4.75,449,1330934400"; 
   d="scan'208";a="222433395"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 5/9] atl1c: remove PHY polling from atl1c_open
Date: Fri, 20 Apr 2012 14:16:20 +0800
Message-ID: <1334902584-15584-6-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334902584-15584-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334902584-15584-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY polling code for FPGA is considered in every MDIO R/W API.
no need to add additional code to atl1c_open.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index cf78287..8a1d2f9 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2273,13 +2273,6 @@ static int atl1c_open(struct net_device *netdev)
 	if (unlikely(err))
 		goto err_up;
 
-	if (adapter->hw.ctrl_flags & ATL1C_FPGA_VERSION) {
-		u32 phy_data;
-
-		AT_READ_REG(&adapter->hw, REG_MDIO_CTRL, &phy_data);
-		phy_data |= MDIO_CTRL_AP_EN;
-		AT_WRITE_REG(&adapter->hw, REG_MDIO_CTRL, phy_data);
-	}
 	return 0;
 
 err_up:
-- 
1.7.7

