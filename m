Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0IGOgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:36:02 -0400
Received: from www.tglx.de ([62.245.132.106]:43949 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab0IGOd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:59 -0400
Message-Id: <20100907125057.179587334@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [patch 26/30] printk: Make console_sem a semaphore not a pseudo mutex
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=printk-console-sem-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to be investigated whether it can be replaced by a real
mutex, but that needs more thought.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(oops_in_progress);
  * provides serialisation for access to the entire console
  * driver system.
  */
-static DECLARE_MUTEX(console_sem);
+static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -556,7 +556,7 @@ static void zap_locks(void)
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
-	init_MUTEX(&console_sem);
+	sema_init(&console_sem, 1);
 }
 
 #if defined(CONFIG_PRINTK_TIME)


