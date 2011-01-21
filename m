Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1AVAPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:15:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34599 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755093Ab1AVAPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:15:03 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+sH0Qd6Iasz1hfby+vF/I+J8zIGEz2iSyQc0YCAR
	ZjZhMlYqzydFHi
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 10/18] h8300: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:56 +0100
Message-Id: <1295651224-29823-11-git-send-email-torbenh@gmx.de>
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
 arch/h8300/kernel/time.c         |    4 +---
 arch/h8300/kernel/timer/timer8.c |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 165005a..32263a1 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -35,9 +35,7 @@ void h8300_timer_tick(void)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 3946c0f..7a1533f 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -61,7 +61,7 @@
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
-- 
1.7.2.3

