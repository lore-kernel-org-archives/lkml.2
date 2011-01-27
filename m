Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1A0O7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:45 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52644 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752586Ab1A0O7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:42 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19p87d56yBp+ywjb9TQAZj7T8DG4N5WEQJ0mtXiQA
	c5ZCZYxUP3KtbV
Subject: [PATCH v2 09/20] cris/arch-v10: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org, Jesper Nilsson <jesper.nilsson@axis.com>,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Mikael Starvik <starvik@axis.com>, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:36 +0100
Message-ID: <20110127145936.23248.16192.stgit@localhost>
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

this code failed to take the xtime_lock, which must be held
when calling do_timer().

use the safe version xtime_update()

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
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

