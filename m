Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992Ab2DMAWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:22:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34405 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966628Ab2DMATL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:19:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="178950455"
X-IronPort-AV: E=Sophos;i="4.75,411,1330934400"; 
   d="scan'208";a="212894374"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 28/37] atl1c: remove PHY polling from atl1c_open
Date: Fri, 13 Apr 2012 08:14:53 +0800
Message-ID: <1334276102-15866-29-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
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
index a85f2af..e43f42f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2272,13 +2272,6 @@ static int atl1c_open(struct net_device *netdev)
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

