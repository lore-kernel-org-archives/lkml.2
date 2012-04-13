Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966447Ab2DMAQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:16:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7073 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966417Ab2DMAQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:16:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="181249736"
X-IronPort-AV: E=Sophos;i="4.75,412,1330934400"; 
   d="scan'208";a="302787771"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 08/37] atl1c: wrong register used to stop TXQ
Date: Fri, 13 Apr 2012 08:14:33 +0800
Message-ID: <1334276102-15866-9-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function atl1c_stop_mac uses wrong register of REG_TWSI_CTRL
to stop mac, replace it with REG_TXQ_CTRL.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index ca1259d..b36c033 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1142,7 +1142,7 @@ static int atl1c_stop_mac(struct atl1c_hw *hw)
 
 	AT_READ_REG(hw, REG_TXQ_CTRL, &data);
 	data &= ~TXQ_CTRL_EN;
-	AT_WRITE_REG(hw, REG_TWSI_CTRL, data);
+	AT_WRITE_REG(hw, REG_TXQ_CTRL, data);
 
 	atl1c_wait_until_idle(hw);
 
-- 
1.7.7

