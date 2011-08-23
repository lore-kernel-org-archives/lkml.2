Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1HWRkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:40:15 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab1HWRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6446"; a="112353748"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 5/6] mmc: msm_sdcc: Change initialization order of busclk_timer in probe
Date: Tue, 23 Aug 2011 10:39:17 -0700
Message-Id: <1314121158-3319-6-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
References: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

Intialize busclk_timer before it is accessed in probe.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index c405e93..a835ac0 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1218,6 +1218,10 @@ msmsdcc_probe(struct platform_device *pdev)
 	host->plat = plat;
 	host->mmc = mmc;
 	host->curr.cmd = NULL;
+	init_timer(&host->busclk_timer);
+	host->busclk_timer.data = (unsigned long) host;
+	host->busclk_timer.function = msmsdcc_busclk_expired;
+
 
 	host->cmdpoll = 1;
 
@@ -1335,10 +1339,6 @@ msmsdcc_probe(struct platform_device *pdev)
 		host->eject = !host->oldstat;
 	}
 
-	init_timer(&host->busclk_timer);
-	host->busclk_timer.data = (unsigned long) host;
-	host->busclk_timer.function = msmsdcc_busclk_expired;
-
 	ret = request_irq(cmd_irqres->start, msmsdcc_irq, IRQF_SHARED,
 			  DRIVER_NAME " (cmd)", host);
 	if (ret)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

