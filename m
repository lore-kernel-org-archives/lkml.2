Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1AVAPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:15:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41875 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab1AVAPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:15:13 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18TEahVr6ITVYIaMt/y27kzJ/jmBPfrDqCvhogPGV
	m4ReyggxJ8ydpA
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 12/18] m32r: switch from do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:58 +0100
Message-Id: <1295651224-29823-13-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() does proper locking.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/m32r/kernel/time.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index bda8682..84dd040 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -107,15 +107,14 @@ u32 arch_gettimeoffset(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
-	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
-	do_timer(1);
+	xtime_update(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
-- 
1.7.2.3

