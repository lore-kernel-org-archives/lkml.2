Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab1KBSmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:42:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254Ab1KBShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706965"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 07/34] msm: clock-debug: Use clk_enable()/clk_disable() directly
Date: Wed,  2 Nov 2011 11:36:04 -0700
Message-Id: <1320258991-22325-8-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The debugfs operations currently sidestep the top level
enable/disable code and directly call the ops->enable/disable
functions. This won't work well when we generically enable parent
clocks in the toplevel clock code. Therefore call enable/disable
directly from the debugfs code to get proper parent enabling.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index bddcbc9..a8db06d 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -55,9 +55,9 @@ static int clock_debug_enable_set(void *data, u64 val)
 	int rc = 0;
 
 	if (val)
-		rc = clock->ops->enable(clock);
+		rc = clk_enable(clock);
 	else
-		clock->ops->disable(clock);
+		clk_disable(clock);
 
 	return rc;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

