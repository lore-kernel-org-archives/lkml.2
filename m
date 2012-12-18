Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2LRXBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:01:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12660 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2LRXBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:01:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,311,1355126400"; 
   d="scan'208";a="14991539"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-arm-msm@vger.kernel.org, Steven Miao <realmz6@gmail.com>,
        trivial@kernel.org
Subject: [PATCH/TRIVIAL] blackfin: time-ts: Remove duplicate assignment
Date: Tue, 18 Dec 2012 15:01:45 -0800
Message-Id: <1355871705-19720-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.1.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that this assignment is done twice in a row. Remove the
duplicate assignment.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Steven Miao <realmz6@gmail.com>
Cc: trivial@kernel.org
---

Noticed while grepping for broadcast users.

 arch/blackfin/kernel/time-ts.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index f608f02..cb0a484 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -329,12 +329,6 @@ void bfin_coretmr_clockevent_init(void)
 	evt->broadcast = smp_timer_broadcast;
 #endif
 
-
-#ifdef CONFIG_SMP
-	evt->broadcast = smp_timer_broadcast;
-#endif
-
-
 	evt->name = "bfin_core_timer";
 	evt->rating = 350;
 	evt->irq = -1;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

