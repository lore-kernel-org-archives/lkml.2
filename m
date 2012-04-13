Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966523Ab2DMARI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:17:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966509Ab2DMARD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:17:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="181249843"
X-IronPort-AV: E=Sophos;i="4.75,411,1330934400"; 
   d="scan'208";a="212892653"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 13/37] atl1c: threshold for ASPM is changed based on chip capability
Date: Fri, 13 Apr 2012 08:14:38 +0800
Message-ID: <1334276102-15866-14-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

threshold setting to control ASPM for diff chips are different.
currently, all gigabit-capability chips have limited-ASPM under
100M throughput.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 18c91b6..8228aa7 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1084,9 +1084,10 @@ static void atl1c_configure_rx(struct atl1c_adapter *adapter)
 	if (hw->ctrl_flags & ATL1C_RX_IPV6_CHKSUM)
 		rxq_ctrl_data |= IPV6_CHKSUM_CTRL_EN;
 
-	if (hw->ctrl_flags & ATL1C_ASPM_CTRL_MON)
-		rxq_ctrl_data |= (ASPM_THRUPUT_LIMIT_1M &
-			ASPM_THRUPUT_LIMIT_MASK) << ASPM_THRUPUT_LIMIT_SHIFT;
+	/* aspm for gigabit */
+	if (hw->nic_type != athr_l1d_2 && (hw->device_id & 1) != 0)
+		rxq_ctrl_data = FIELD_SETX(rxq_ctrl_data, ASPM_THRUPUT_LIMIT,
+			ASPM_THRUPUT_LIMIT_100M);
 
 	AT_WRITE_REG(hw, REG_RXQ_CTRL, rxq_ctrl_data);
 }
-- 
1.7.7

