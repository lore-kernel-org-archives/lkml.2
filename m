Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966365Ab2DMAPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:15:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2583 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966327Ab2DMAPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:15:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="181249504"
X-IronPort-AV: E=Sophos;i="4.75,411,1330934400"; 
   d="scan'208";a="196065956"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 03/37] atl1c: remove HDS register
Date: Fri, 13 Apr 2012 08:14:28 +0800
Message-ID: <1334276102-15866-4-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove HDS register as it doesn't exist in hardware.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |    7 -------
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 --
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index 855aca0..c22d698 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -669,13 +669,6 @@ int atl1c_phy_power_saving(struct atl1c_hw *hw);
 #define REG_INT_RETRIG_TIMER		0x1608
 #define INT_RETRIG_TIMER_MASK		0xFFFF
 
-#define REG_HDS_CTRL			0x160C
-#define HDS_CTRL_EN			0x0001
-#define HDS_CTRL_BACKFILLSIZE_SHIFT	8
-#define HDS_CTRL_BACKFILLSIZE_MASK	0x0FFF
-#define HDS_CTRL_MAX_HDRSIZE_SHIFT	20
-#define HDS_CTRL_MAC_HDRSIZE_MASK	0x0FFF
-
 #define REG_MAC_RX_STATUS_BIN 		0x1700
 #define REG_MAC_RX_STATUS_END 		0x175c
 #define REG_MAC_TX_STATUS_BIN 		0x1760
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 226be99..885e892 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1453,8 +1453,6 @@ static int atl1c_configure(struct atl1c_adapter *adapter)
 	/* set MTU */
 	AT_WRITE_REG(hw, REG_MTU, hw->max_frame_size + ETH_HLEN +
 			VLAN_HLEN + ETH_FCS_LEN);
-	/* HDS, disable */
-	AT_WRITE_REG(hw, REG_HDS_CTRL, 0);
 
 	atl1c_configure_tx(adapter);
 	atl1c_configure_rx(adapter);
-- 
1.7.7

