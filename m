Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1CRV71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:59:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60656 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab1CRV7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850505"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045025"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] video: msm: convert printk to pr_*
Date: Fri, 18 Mar 2011 14:59:12 -0700
Message-Id: <1300485552-27519-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reword debugging messages to use pr_err and pr_warning

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 8184ca9..b03204d 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -42,16 +42,13 @@ DEFINE_MUTEX(mdp_mutex);
 
 static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
 {
-	int ret = 0;
-
 	BUG_ON(!mask);
 
 	/* if the mask bits are already set return an error, this interrupt
 	 * is already enabled */
 	if (mdp_irq_mask & mask) {
-		printk(KERN_ERR "mdp irq already on already on %x %x\n",
-		       mdp_irq_mask, mask);
-		ret = -1;
+		pr_err("mdp irq already on %x %x\n", mdp_irq_mask, mask);
+		return -1;
 	}
 	/* if the mdp irq is not already enabled enable it */
 	if (!mdp_irq_mask) {
@@ -172,9 +169,9 @@ static int mdp_wait(struct mdp_info *mdp, uint32_t mask, wait_queue_head_t *wq)
 
 	spin_lock_irqsave(&mdp->lock, irq_flags);
 	if (mdp_irq_mask & mask) {
+		pr_warning("%s: timeout waiting for mdp to complete 0x%x\n",
+			   __func__, mask);
 		locked_disable_mdp_irq(mdp, mask);
-		printk(KERN_WARNING "timeout waiting for mdp to complete %x\n",
-		       mask);
 		ret = -ETIMEDOUT;
 	}
 	spin_unlock_irqrestore(&mdp->lock, irq_flags);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

