Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1A0O76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35298 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752539Ab1A0O74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:56 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19JgjsH0XJJAq3EQUkVgqtzw9yA4PMRoSWScSW5/l
	C4g/l3o/6GdW8d
Subject: [PATCH v2 12/20] h8300: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:51 +0100
Message-ID: <20110127145951.23248.92727.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.


Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
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

