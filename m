Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2DTGRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:17:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1672 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2DTGRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:17:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="181080445"
X-IronPort-AV: E=Sophos;i="4.75,449,1330934400"; 
   d="scan'208";a="238421035"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 7/9] atl1c: remove PHY reset/init for link down event
Date: Fri, 20 Apr 2012 14:16:22 +0800
Message-ID: <1334902584-15584-8-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334902584-15584-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334902584-15584-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's unnecessary to reset/init phy when link down.
Only L1/L2 chip (supported by atlx) need such action.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 995da22..cb3b3c4 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -270,8 +270,6 @@ static void atl1c_check_link_status(struct atl1c_adapter *adapter)
 		atl1c_set_aspm(hw, SPEED_0);
 		netif_carrier_off(netdev);
 		netif_stop_queue(netdev);
-		atl1c_phy_reset(hw);
-		atl1c_phy_init(&adapter->hw);
 	} else {
 		/* Link Up */
 		hw->hibernate = false;
-- 
1.7.7

