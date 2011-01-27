Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1A0PAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:54319 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752864Ab1A0PAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:06 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18y6yQj49EyBzVHgcpALnnvbo3TNFB5CNFgNbGHEx
	v9yAGV3a+JaiM7
Subject: [PATCH v2 14/20] m32r: switch from do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Hirokazu Takata <takata@linux-m32r.org>, hch@infradead.org,
        yong.zhang0@gmail.com, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 16:00:01 +0100
Message-ID: <20110127150001.23248.68620.stgit@localhost>
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

xtime_update() does proper locking.

Cc: Hirokazu Takata <takata@linux-m32r.org>
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

