Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2DRAWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:22:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2DRAVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:21:17 -0400
Message-Id: <8675ae$5bugru@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="180306814"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 7 Mar 2012 15:27:23 -0600
Subject: [PATCH 08/10] hexagon:  use renamed tick_nohz_idle_* functions
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/process.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 18c4f0b..ff02821 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -1,7 +1,7 @@
 /*
  * Process creation support for Hexagon
  *
- * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2010-2012, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -88,7 +88,7 @@ void (*idle_sleep)(void) = default_idle;
 void cpu_idle(void)
 {
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		local_irq_disable();
 		while (!need_resched()) {
 			idle_sleep();
@@ -97,7 +97,7 @@ void cpu_idle(void)
 			local_irq_disable();
 		}
 		local_irq_enable();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		schedule();
 	}
 }
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
