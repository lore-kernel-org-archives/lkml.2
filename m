Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1AUXH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:07:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50964 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754408Ab1AUXHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:24 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18NhnNpEX0NhgkVNuhUm0a/6SBSs/8lW019vIGVC2
	Usp0QQUr2aOJ26
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 08/18] cris/arch-v32: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:54 +0100
Message-Id: <1295651224-29823-9-git-send-email-torbenh@gmx.de>
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
 arch/cris/arch-v32/kernel/time.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index a545211..bb978ed 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -183,7 +183,7 @@ void handle_watchdog_bite(struct pt_regs *regs)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick.
+ * as well as call the "xtime_update()" routine every clocktick.
  */
 extern void cris_do_profile(struct pt_regs *regs);
 
@@ -216,9 +216,7 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 
 	/* Call the real timer interrupt handler */
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
         return IRQ_HANDLED;
 }
 
-- 
1.7.2.3

