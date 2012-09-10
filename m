Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2IJMBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:01:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:39703 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2IJMBV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 08:01:21 -0400
Message-Id: <504DF2AC020000780009A2DF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:01:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust spin lock inlining Kconfig options
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out the DEBUG_SPINLOCK dependency (requires moving up
UNINLINE_SPIN_UNLOCK, as this was the only one in that block not
depending on that option).

Avoid putting values not selected into the resulting .config - they are
not useful for anything, make the output less legible, and just consume
space: Use "depends on" rather than directly setting the default from
the combined dependency values.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 kernel/Kconfig.locks |  103 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 40 deletions(-)

--- 3.6-rc5/kernel/Kconfig.locks
+++ 3.6-rc5-kconfig-cleanup-locks/kernel/Kconfig.locks
@@ -87,6 +87,9 @@ config ARCH_INLINE_WRITE_UNLOCK_IRQ
 config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	bool
 
+config UNINLINE_SPIN_UNLOCK
+	bool
+
 #
 # lock_* functions are inlined when:
 #   - DEBUG_SPINLOCK=n and GENERIC_LOCKBREAK=n and ARCH_INLINE_*LOCK=y
@@ -103,100 +106,120 @@ config ARCH_INLINE_WRITE_UNLOCK_IRQRESTO
 #   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
 #
 
+if !DEBUG_SPINLOCK
+
 config INLINE_SPIN_TRYLOCK
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK
+	def_bool y
+	depends on ARCH_INLINE_SPIN_TRYLOCK
 
 config INLINE_SPIN_TRYLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_SPIN_TRYLOCK_BH
 
 config INLINE_SPIN_LOCK
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK
 
 config INLINE_SPIN_LOCK_BH
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_SPIN_LOCK_BH
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK_BH
 
 config INLINE_SPIN_LOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_SPIN_LOCK_IRQ
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK_IRQ
 
 config INLINE_SPIN_LOCK_IRQSAVE
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
-
-config UNINLINE_SPIN_UNLOCK
-	bool
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK_IRQSAVE
 
 config INLINE_SPIN_UNLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQRESTORE
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+	def_bool y
+	depends on ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
 
 
 config INLINE_READ_TRYLOCK
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_TRYLOCK
+	def_bool y
+	depends on ARCH_INLINE_READ_TRYLOCK
 
 config INLINE_READ_LOCK
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK
 
 config INLINE_READ_LOCK_BH
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_READ_LOCK_BH
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK_BH
 
 config INLINE_READ_LOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_READ_LOCK_IRQ
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK_IRQ
 
 config INLINE_READ_LOCK_IRQSAVE
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_READ_LOCK_IRQSAVE
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK_IRQSAVE
 
 config INLINE_READ_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK
 
 config INLINE_READ_UNLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK_BH)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQRESTORE
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+	def_bool y
+	depends on ARCH_INLINE_READ_UNLOCK_IRQRESTORE
 
 
 config INLINE_WRITE_TRYLOCK
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_TRYLOCK
+	def_bool y
+	depends on ARCH_INLINE_WRITE_TRYLOCK
 
 config INLINE_WRITE_LOCK
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK
 
 config INLINE_WRITE_LOCK_BH
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_WRITE_LOCK_BH
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK_BH
 
 config INLINE_WRITE_LOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_WRITE_LOCK_IRQ
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK_IRQ
 
 config INLINE_WRITE_LOCK_IRQSAVE
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_WRITE_LOCK_IRQSAVE
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK_IRQSAVE
 
 config INLINE_WRITE_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK
 
 config INLINE_WRITE_UNLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQRESTORE
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	def_bool y
+	depends on ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+
+endif
 
 config MUTEX_SPIN_ON_OWNER
-	def_bool SMP && !DEBUG_MUTEXES
+	def_bool y
+	depends on SMP && !DEBUG_MUTEXES


