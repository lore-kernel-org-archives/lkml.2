Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1CRV7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:59:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18053 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab1CRV7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850455"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045015"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] video: msm: Write IRQ mask to MDP registers
Date: Fri, 18 Mar 2011 14:58:58 -0700
Message-Id: <1300485538-27479-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing MDP IRQ mask to the MDP IRQ register to fully disable interrupt.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index bdca2d9..8184ca9 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -59,9 +59,13 @@ static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 		enable_irq(mdp->irq);
 	}
 
+	/* clear out any previous irqs for the requested mask*/
+	mdp_writel(mdp, mask, MDP_INTR_CLEAR);
+
 	/* update the irq mask to reflect the fact that the interrupt is
 	 * enabled */
 	mdp_irq_mask |= mask;
+	mdp_writel(mdp, mdp_irq_mask, MDP_INTR_ENABLE);
 	return 0;
 }
 
@@ -87,6 +91,8 @@ static int locked_disable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 	/* update the irq mask to reflect the fact that the interrupt is
 	 * disabled */
 	mdp_irq_mask &= ~(mask);
+	mdp_writel(mdp, mdp_irq_mask, MDP_INTR_ENABLE);
+
 	/* if no one is waiting on the interrupt, disable it */
 	if (!mdp_irq_mask) {
 		disable_irq_nosync(mdp->irq);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

