Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1AUXIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:08:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58329 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754316Ab1AUXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:23 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+P+RhNXMCPBWuTwEeMGwExPJLlx/Rp9iyMa+HF6D
	g93ohF9MjCt3eT
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 06/18] blackfin: switch from do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:52 +0100
Message-Id: <1295651224-29823-7-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/blackfin/kernel/time.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index c911361..8d73724 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -114,16 +114,14 @@ u32 arch_gettimeoffset(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 #ifdef CONFIG_CORE_TIMER_IRQ_L1
 __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
-- 
1.7.2.3

