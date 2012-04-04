Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2DDHp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:45:57 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:15185 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2DDHpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:45:55 -0400
Date: Wed, 4 Apr 2012 09:45:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: [PATCH] irq: remove obsolete definitions in interrupt.h
Message-ID: <20120404074553.GA14959@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt.h contained a small fixlet for the days when
m68k and sparc32 did not use genirq.
As they have both entered the modern world this
fixlet can be dropped.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: "David S. Miller" <davem@davemloft.net>
---

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2aea5d2..3848176 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -122,7 +122,6 @@ struct irqaction {
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check
 request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		     irq_handler_t thread_fn,
@@ -144,42 +143,6 @@ request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		   const char *devname, void __percpu *percpu_dev_id);
 
 extern void exit_irq_thread(void);
-#else
-
-extern int __must_check
-request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
-	    const char *name, void *dev);
-
-/*
- * Special function to avoid ifdeffery in kernel/irq/devres.c which
- * gets magically built by GENERIC_HARDIRQS=n architectures (sparc,
- * m68k). I really love these $@%#!* obvious Makefile references:
- * ../../../kernel/irq/devres.o
- */
-static inline int __must_check
-request_threaded_irq(unsigned int irq, irq_handler_t handler,
-		     irq_handler_t thread_fn,
-		     unsigned long flags, const char *name, void *dev)
-{
-	return request_irq(irq, handler, flags, name, dev);
-}
-
-static inline int __must_check
-request_any_context_irq(unsigned int irq, irq_handler_t handler,
-			unsigned long flags, const char *name, void *dev_id)
-{
-	return request_irq(irq, handler, flags, name, dev_id);
-}
-
-static inline int __must_check
-request_percpu_irq(unsigned int irq, irq_handler_t handler,
-		   const char *devname, void __percpu *percpu_dev_id)
-{
-	return request_irq(irq, handler, 0, devname, percpu_dev_id);
-}
-
-static inline void exit_irq_thread(void) { }
-#endif
 
 extern void free_irq(unsigned int, void *);
 extern void free_percpu_irq(unsigned int, void __percpu *);

