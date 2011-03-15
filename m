Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1COFBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36260 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1COFBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79772013"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 03/11] msm: dma: support using dma from modules
Date: Mon, 14 Mar 2011 22:01:06 -0700
Message-Id: <1300165274-8544-4-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/dma.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 8e4d46e..1f487b8 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/completion.h>
+#include <linux/module.h>
 #include <mach/dma.h>
 
 #define MSM_DMOV_CHANNEL_COUNT 16
@@ -52,6 +53,7 @@ void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
 {
 	writel((graceful << 31), DMOV_FLUSH0(id));
 }
+EXPORT_SYMBOL(msm_dmov_stop_cmd);
 
 void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 {
@@ -90,6 +92,7 @@ void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 	}
 	spin_unlock_irqrestore(&msm_dmov_lock, irq_flags);
 }
+EXPORT_SYMBOL(msm_dmov_enqueue_cmd);
 
 void msm_dmov_flush(unsigned int id)
 {
@@ -102,6 +105,7 @@ void msm_dmov_flush(unsigned int id)
 	}
 	spin_unlock_irqrestore(&msm_dmov_lock, flags);
 }
+EXPORT_SYMBOL(msm_dmov_flush);
 
 struct msm_dmov_exec_cmdptr_cmd {
 	struct msm_dmov_cmd dmov_cmd;
@@ -148,7 +152,7 @@ int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr)
 	PRINT_FLOW("dmov_exec_cmdptr(%d, %x) done\n", id, cmdptr);
 	return 0;
 }
-
+EXPORT_SYMBOL(msm_dmov_exec_cmd);
 
 static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

