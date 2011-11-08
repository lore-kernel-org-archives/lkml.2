Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1KHSeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:34:15 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1KHSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133442199"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/8] msm: timer: Tighten #ifdef for local timer support
Date: Tue,  8 Nov 2011 10:34:03 -0800
Message-Id: <1320777250-23263-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more correct to only define the local timer support code
when CONFIG_LOCAL_TIMERS=y.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index afeeca5..1cab559 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -279,7 +279,7 @@ static void __init msm_timer_init(void)
 	}
 }
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_LOCAL_TIMERS
 int __cpuinit local_timer_setup(struct clock_event_device *evt)
 {
 	static bool local_timer_inited;
@@ -321,8 +321,7 @@ void local_timer_stop(struct clock_event_device *evt)
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
 	disable_percpu_irq(evt->irq);
 }
-
-#endif
+#endif /* CONFIG_LOCAL_TIMERS */
 
 struct sys_timer msm_timer = {
 	.init = msm_timer_init
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

