Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab1CaUD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:03:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15498 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab1CaUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:03:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6302"; a="83258583"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] msm: timer: fix missing return value
Date: Thu, 31 Mar 2011 13:04:23 -0700
Message-Id: <1301601863-19554-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301601863-19554-1-git-send-email-davidb@codeaurora.org>
References: <1301601863-19554-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change af90f10d38 "ARM: 6759/1: smp: Select local timers vs broadcast
timer support runtime" missed a return statement, causing a compile
warning:

  arch/arm/mach-msm/timer.c:272: warning: 'return' with no value, in
  function returning non-void

Trivially return 0 for success when running on cpu 0 (to match the
comment and previous behavior).

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 56f920c..38b95e9 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -269,7 +269,7 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 
 	/* Use existing clock_event for cpu 0 */
 	if (!smp_processor_id())
-		return;
+		return 0;
 
 	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

