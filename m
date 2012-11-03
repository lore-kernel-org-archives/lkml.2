Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2KCLAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:00:00 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62865
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813Ab2KCK6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245677"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] drivers/infiniband/hw/nes: use WARN
Date: Sat,  3 Nov 2012 11:58:37 +0100
Message-Id: <1351940317-14812-17-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/nes/nes_cm.c  |    6 ++----
 drivers/infiniband/hw/nes/nes_mgt.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index cfaacaf..8a15a1d 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -629,11 +629,9 @@ static void build_rdma0_msg(struct nes_cm_node *cm_node, struct nes_qp **nesqp_a
 
 	case SEND_RDMA_READ_ZERO:
 	default:
-		if (cm_node->send_rdma0_op != SEND_RDMA_READ_ZERO) {
-			printk(KERN_ERR "%s[%u]: Unsupported RDMA0 len operation=%u\n",
+		if (cm_node->send_rdma0_op != SEND_RDMA_READ_ZERO)
+			WARN(1, KERN_ERR "%s[%u]: Unsupported RDMA0 len operation=%u\n",
 				 __func__, __LINE__, cm_node->send_rdma0_op);
-			WARN_ON(1);
-		}
 		nes_debug(NES_DBG_CM, "Sending first rdma operation.\n");
 		wqe->wqe_words[NES_IWARP_SQ_WQE_MISC_IDX] =
 			cpu_to_le32(NES_IWARP_SQ_OP_RDMAR);
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 3ba7be3..53bb88c 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -649,11 +649,9 @@ static void nes_chg_qh_handler(struct nes_device *nesdev, struct nes_cqp_request
 	nesqp = qh_chg->nesqp;
 
 	/* Should we handle the bad completion */
-	if (cqp_request->major_code) {
-		printk(KERN_ERR PFX "Invalid cqp_request major_code=0x%x\n",
+	if (cqp_request->major_code)
+		WARN(1, KERN_ERR PFX "Invalid cqp_request major_code=0x%x\n",
 		       cqp_request->major_code);
-		WARN_ON(1);
-	}
 
 	switch (nesqp->pau_state) {
 	case PAU_DEL_QH:

