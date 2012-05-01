Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2EABkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:40:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10634 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2EABkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:40:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="186394428"
X-IronPort-AV: E=Sophos;i="4.75,507,1330934400"; 
   d="scan'208";a="158949930"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 10/10] atl1c: remove PHY polling from atl1c_change_mtu
Date: Tue, 1 May 2012 09:38:58 +0800
Message-ID: <1335836338-9425-11-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY polling code for FPGA is considered in every MDIO R/W API.
no need to add additional code to atl1c_change_mtu.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: David Liu <dwliu@qca.qaulcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 05ce8ec..9cc1570 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -553,14 +553,6 @@ static int atl1c_change_mtu(struct net_device *netdev, int new_mtu)
 		netdev_update_features(netdev);
 		atl1c_up(adapter);
 		clear_bit(__AT_RESETTING, &adapter->flags);
-		if (adapter->hw.ctrl_flags & ATL1C_FPGA_VERSION) {
-			u32 phy_data;
-
-			AT_READ_REG(&adapter->hw, 0x1414, &phy_data);
-			phy_data |= 0x10000000;
-			AT_WRITE_REG(&adapter->hw, 0x1414, phy_data);
-		}
-
 	}
 	return 0;
 }
-- 
1.7.7

