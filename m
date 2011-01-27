Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1A0O7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:42 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48216 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752564Ab1A0O7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:40 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19t3uJAgadt+iRPgdr7JPPNcWtI3FRiLZ8hYxAbY1
	maJgkquLmiPwQW
Subject: [PATCH v2 08/20] blackfin: switch from do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Mike Frysinger <vapier@gentoo.org>, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:31 +0100
Message-ID: <20110127145931.23248.33917.stgit@localhost>
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


Cc: Mike Frysinger <vapier@gentoo.org>
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

