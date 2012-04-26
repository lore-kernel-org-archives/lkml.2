Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2DZG2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:28:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25420 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2DZG2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:28:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="185052095"
X-IronPort-AV: E=Sophos;i="4.75,484,1330934400"; 
   d="scan'208";a="241381704"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 05/10] atl1c: remove PHY polling from atl1c_open
Date: Thu, 26 Apr 2012 14:27:13 +0800
Message-ID: <1335421638-16304-6-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335421638-16304-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335421638-16304-1-git-send-email-xiong@qca.qualcomm.com>
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

