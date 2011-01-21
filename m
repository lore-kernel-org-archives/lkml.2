Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1AUXHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:07:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33251 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754370Ab1AUXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:23 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+P+RhNXMCPBWuTwEeMGwExPJLlx/Rp9iyMa+HF6D
	g93ohF9MjCt3eT
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 07/18] cris/arch-v10: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:53 +0100
Message-Id: <1295651224-29823-8-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this code failed to take the xtime_lock, which must be held
when calling do_timer().

use the safe version xtime_update()

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/cris/arch-v10/kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 00eb36f..20c85b5 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -140,7 +140,7 @@ stop_watchdog(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 //static unsigned short myjiff; /* used by our debug routine print_timestamp */
@@ -176,7 +176,7 @@ timer_interrupt(int irq, void *dev_id)
 
 	/* call the real timer interrupt handler */
 
-	do_timer(1);
+	xtime_update(1);
 	
         cris_do_profile(regs); /* Save profiling information */
         return IRQ_HANDLED;
-- 
1.7.2.3

