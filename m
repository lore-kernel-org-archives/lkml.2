Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2EABkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:40:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5602 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2EABkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:40:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="184143868"
X-IronPort-AV: E=Sophos;i="4.75,504,1330934400"; 
   d="scan'208";a="207777498"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 09/10] atl1c: Disable L0S when no cable link
Date: Tue, 1 May 2012 09:38:57 +0800
Message-ID: <1335836338-9425-10-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L0S might be unstable if no cable link, only enable it when link up.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index e6c62d0..05ce8ec 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1326,7 +1326,7 @@ static void atl1c_set_aspm(struct atl1c_hw *hw, u16 link_speed)
 	}
 
 	/* L0S/L1 enable */
-	if (hw->ctrl_flags & ATL1C_ASPM_L0S_SUPPORT)
+	if ((hw->ctrl_flags & ATL1C_ASPM_L0S_SUPPORT) && link_speed != SPEED_0)
 		pm_ctrl_data |= PM_CTRL_ASPM_L0S_EN | PM_CTRL_MAC_ASPM_CHK;
 	if (hw->ctrl_flags & ATL1C_ASPM_L1_SUPPORT)
 		pm_ctrl_data |= PM_CTRL_ASPM_L1_EN | PM_CTRL_MAC_ASPM_CHK;
-- 
1.7.7

