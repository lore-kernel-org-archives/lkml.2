Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2DRFeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:34:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21715 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2DRFeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:34:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="180355853"
X-IronPort-AV: E=Sophos;i="4.75,438,1330934400"; 
   d="scan'208";a="120453691"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 10/12] atl1c: remove dmaw_block
Date: Wed, 18 Apr 2012 13:32:34 +0800
Message-ID: <1334727156-6830-11-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaw_block is never used in the driver, remove it.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h      |    1 -
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 973c568..0a4bfab 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -374,7 +374,6 @@ struct atl1c_hw {
 	enum atl1c_dma_order dma_order;
 	enum atl1c_dma_rcb   rcb_value;
 	enum atl1c_dma_req_block dmar_block;
-	enum atl1c_dma_req_block dmaw_block;
 
 	u16 device_id;
 	u16 vendor_id;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1ce48d0..d6ebaa4 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -740,7 +740,6 @@ static int __devinit atl1c_sw_init(struct atl1c_adapter *adapter)
 	hw->rfd_burst = 8;
 	hw->dma_order = atl1c_dma_ord_out;
 	hw->dmar_block = atl1c_dma_req_1024;
-	hw->dmaw_block = atl1c_dma_req_1024;
 	hw->dmar_dly_cnt = 15;
 	hw->dmaw_dly_cnt = 4;
 
@@ -1056,9 +1055,6 @@ static void atl1c_configure_tx(struct atl1c_adapter *adapter)
 	AT_WRITE_REG(hw, REG_TX_TSO_OFFLOAD_THRESH,
 		(tx_offload_thresh >> 3) & TX_TSO_OFFLOAD_THRESH_MASK);
 	AT_READ_REG(hw, REG_DEVICE_CTRL, &dev_ctrl_data);
-	max_pay_load  = (dev_ctrl_data >> DEVICE_CTRL_MAX_PAYLOAD_SHIFT) &
-			DEVICE_CTRL_MAX_PAYLOAD_MASK;
-	hw->dmaw_block = min_t(u32, max_pay_load, hw->dmaw_block);
 	max_pay_load  = (dev_ctrl_data >> DEVICE_CTRL_MAX_RREQ_SZ_SHIFT) &
 			DEVICE_CTRL_MAX_RREQ_SZ_MASK;
 	hw->dmar_block = min_t(u32, max_pay_load, hw->dmar_block);
-- 
1.7.7

