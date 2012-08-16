Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2HPPKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:10:46 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:48266 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab2HPPKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:10:43 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] blackfin: Use schedule_preempt_disabled()
Date: Thu, 16 Aug 2012 17:02:15 +0200
Message-Id: <1345129335-23688-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.8.16.145125
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 HTML_NO_HTTP 0.1, MULTIPLE_RCPTS 0.1, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_800_899 0, NO_URI_FOUND 0, __HAS_FROM 0, __HAS_HTML 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow bd2f5536 (sched/rt: Use schedule_preempt_disabled()).

b5affb014 (blackfin: add bf60x to current framework) accidentally (?)
reverted the change.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/blackfin/kernel/process.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 62bcea7..8936bbb 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -95,9 +95,7 @@ void cpu_idle(void)
 			idle();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
-- 
1.7.5.4

