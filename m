Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab0LTXRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:17:13 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10808 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab0LTXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:17:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67414637"
From: Daniel Walker <dwalker@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 3/5] mmc: msm: fix msmsdcc_disable_clocks spinlock protection
Date: Mon, 20 Dec 2010 15:16:49 -0800
Message-Id: <1292887011-30006-3-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function msmsdcc_disable_clocks needs to be called with
the host lock held.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 01bb684..c64a659 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -261,10 +261,10 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 			host->curr.cmd = NULL;
 			mrq->data->bytes_xfered = host->curr.data_xfered;
 
-			spin_unlock_irqrestore(&host->lock, flags);
-
 			msmsdcc_disable_clocks(host, 1);
 
+			spin_unlock_irqrestore(&host->lock, flags);
+
 			mmc_request_done(host->mmc, mrq);
 			return;
 		} else
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
