Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab2D1B76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 21:59:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59884 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab2D1B7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 21:59:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6694"; a="183515912"
X-IronPort-AV: E=Sophos;i="4.75,491,1330934400"; 
   d="scan'208";a="242469599"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 06/10] atl1c: enlarge L1 response waiting timer
Date: Sat, 28 Apr 2012 09:58:41 +0800
Message-ID: <1335578325-21326-7-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335578325-21326-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335578325-21326-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware incorrectly process L0S/L1 entrance if the chipset/root
response after specific/shorter timer and cause system hang.
Enlarge the timeout value to avoid this issue.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index 21a5bc1..17d935b 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -157,7 +157,7 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 #define PM_CTRL_PM_REQ_TIMER_MASK	0xFUL
 #define PM_CTRL_PM_REQ_TIMER_SHIFT	20	/* pm_request_l1 time > @
 						 * ->L0s not L1 */
-#define PM_CTRL_PM_REQ_TO_DEF		0xC
+#define PM_CTRL_PM_REQ_TO_DEF		0xF
 #define PMCTRL_TXL1_AFTER_L0S		BIT(19)	/* l1dv2.0+ */
 #define L1D_PMCTRL_L1_ENTRY_TM_MASK	7UL	/* l1dv2.0+, 3bits */
 #define L1D_PMCTRL_L1_ENTRY_TM_SHIFT	16
-- 
1.7.7

