Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2INGZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:25:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2INGZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:25:40 -0400
Date: Thu, 13 Sep 2012 23:25:18 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-4fe84fb8c6b5081f7364af63aee8e118a665b966@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <504DF2AC020000780009A2DF@nat28.tlf.novell.com>
References: <504DF2AC020000780009A2DF@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking:
  Adjust spin lock inlining Kconfig options
Git-Commit-ID: 4fe84fb8c6b5081f7364af63aee8e118a665b966
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:25:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fe84fb8c6b5081f7364af63aee8e118a665b966
Gitweb:     http://git.kernel.org/tip/4fe84fb8c6b5081f7364af63aee8e118a665b966
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 10 Sep 2012 13:01:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:56:13 +0200

locking: Adjust spin lock inlining Kconfig options

Break out the DEBUG_SPINLOCK dependency (requires moving up
UNINLINE_SPIN_UNLOCK, as this was the only one in that block not
depending on that option).

Avoid putting values not selected into the resulting .config -
they are not useful for anything, make the output less legible,
and just consume space: Use "depends on" rather than directly
setting the default from the combined dependency values.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/504DF2AC020000780009A2DF@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Kconfig.locks |  103 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 63 insertions(+), 40 deletions(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 2251882..44511d1 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -87,6 +87,9 @@ config ARCH_INLINE_WRITE_UNLOCK_IRQ
 config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	bool
 
+config UNINLINE_SPIN_UNLOCK
+	bool
+
 #
 # lock_* functions are inlined when:
 #   - DEBUG_SPINLOCK=n and GENERIC_LOCKBREAK=n and ARCH_INLINE_*LOCK=y
@@ -103,100 +106,120 @@ config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
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
