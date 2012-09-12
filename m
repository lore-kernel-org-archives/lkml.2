Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730Ab2ILRDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:03:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2ILQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521471"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 20/24] ARM: msm: dma: use list_move_tail instead of list_del/list_add_tail
Date: Wed, 12 Sep 2012 09:58:56 -0700
Message-Id: <1347469140-25069-21-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 02cae5e..354b91d 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -223,8 +223,7 @@ static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 			PRINT_FLOW("msm_datamover_irq_handler id %d, status %x\n", id, ch_status);
 			if ((ch_status & DMOV_STATUS_CMD_PTR_RDY) && !list_empty(&ready_commands[id])) {
 				cmd = list_entry(ready_commands[id].next, typeof(*cmd), list);
-				list_del(&cmd->list);
-				list_add_tail(&cmd->list, &active_commands[id]);
+				list_move_tail(&cmd->list, &active_commands[id]);
 				if (cmd->execute_func)
 					cmd->execute_func(cmd);
 				PRINT_FLOW("msm_datamover_irq_handler id %d, start command\n", id);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

