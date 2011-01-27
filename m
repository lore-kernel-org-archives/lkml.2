Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1A0O7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48070 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752669Ab1A0O7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:46 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19gGUJrvxNg/YrbkPE3QHXul28cQr4vYlDbDXX3Ga
	jfbke0geeB4r3+
Subject: [PATCH v2 10/20] cris/arch-v32: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org, Jesper Nilsson <jesper.nilsson@axis.com>,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Mikael Starvik <starvik@axis.com>, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:41 +0100
Message-ID: <20110127145941.23248.92547.stgit@localhost>
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

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
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
 

