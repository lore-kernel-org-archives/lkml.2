Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2CWTpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:45:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2CWTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:45:18 -0400
Date: Fri, 23 Mar 2012 12:44:46 -0700
From: tip-bot for Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Message-ID: <tip-e335e3eb82dada2765297f6ba501afc7555aba10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com, chris@zankel.net,
        raghavendra.kt@linux.vnet.ibm.com, ralf@linux-mips.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com, chris@zankel.net,
        raghavendra.kt@linux.vnet.ibm.com, ralf@linux-mips.org,
        tglx@linutronix.de
In-Reply-To: <20120322095502.30866.75756.sendpatchset@codeblue>
References: <20120322095502.30866.75756.sendpatchset@codeblue>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] locking/kconfig:
  Simplify INLINE_SPIN_UNLOCK usage
Git-Commit-ID: e335e3eb82dada2765297f6ba501afc7555aba10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 12:44:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e335e3eb82dada2765297f6ba501afc7555aba10
Gitweb:     http://git.kernel.org/tip/e335e3eb82dada2765297f6ba501afc7555aba10
Author:     Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
AuthorDate: Thu, 22 Mar 2012 15:25:08 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 23 Mar 2012 13:18:57 +0100

locking/kconfig: Simplify INLINE_SPIN_UNLOCK usage

Get rid of INLINE_SPIN_UNLOCK entirely replacing it with
UNINLINE_SPIN_UNLOCK instead of the reverse meaning.

Whoever wants to change the default spinlock inlining
behavior and uninline the spinlocks for some weird reason,
such as spinlock debugging, paravirt etc. can now all just
select UNINLINE_SPIN_UNLOCK

Original discussion at: https://lkml.org/lkml/2012/3/21/357

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20120322095502.30866.75756.sendpatchset@codeblue
[ tidied up the changelog a bit ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/configs/db1300_defconfig |    2 +-
 arch/xtensa/configs/iss_defconfig  |    2 +-
 include/linux/spinlock_api_smp.h   |    2 +-
 kernel/Kconfig.locks               |    4 ++--
 kernel/Kconfig.preempt             |    1 +
 kernel/spinlock.c                  |    2 +-
 lib/Kconfig.debug                  |    1 +
 7 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/mips/configs/db1300_defconfig b/arch/mips/configs/db1300_defconfig
index c38b190..3590ab5 100644
--- a/arch/mips/configs/db1300_defconfig
+++ b/arch/mips/configs/db1300_defconfig
@@ -133,7 +133,7 @@ CONFIG_BLK_DEV_BSG=y
 CONFIG_IOSCHED_NOOP=y
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_UNINLINE_SPIN_UNLOCK is not set
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
 CONFIG_INLINE_READ_UNLOCK=y
 CONFIG_INLINE_READ_UNLOCK_IRQ=y
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index f932b30..ddab37b 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -113,7 +113,7 @@ CONFIG_DEFAULT_IOSCHED="noop"
 # CONFIG_INLINE_SPIN_LOCK_BH is not set
 # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
 # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
-CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_UNINLINE_SPIN_UNLOCK is not set
 # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
 # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index e253ccd..51df117 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -67,7 +67,7 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 #define _raw_spin_trylock_bh(lock) __raw_spin_trylock_bh(lock)
 #endif
 
-#ifdef CONFIG_INLINE_SPIN_UNLOCK
+#ifndef CONFIG_UNINLINE_SPIN_UNLOCK
 #define _raw_spin_unlock(lock) __raw_spin_unlock(lock)
 #endif
 
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 5068e2a..2251882 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -124,8 +124,8 @@ config INLINE_SPIN_LOCK_IRQSAVE
 	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
 		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
 
-config INLINE_SPIN_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK)
+config UNINLINE_SPIN_UNLOCK
+	bool
 
 config INLINE_SPIN_UNLOCK_BH
 	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 24e7cb0..3f9c974 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -36,6 +36,7 @@ config PREEMPT_VOLUNTARY
 config PREEMPT
 	bool "Preemptible Kernel (Low-Latency Desktop)"
 	select PREEMPT_COUNT
+	select UNINLINE_SPIN_UNLOCK if !ARCH_INLINE_SPIN_UNLOCK
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 84c7d96..5cdd806 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -163,7 +163,7 @@ void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
 EXPORT_SYMBOL(_raw_spin_lock_bh);
 #endif
 
-#ifndef CONFIG_INLINE_SPIN_UNLOCK
+#ifdef CONFIG_UNINLINE_SPIN_UNLOCK
 void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock(lock);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 05037dc..f32a41f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -499,6 +499,7 @@ config RT_MUTEX_TESTER
 config DEBUG_SPINLOCK
 	bool "Spinlock and rw-lock debugging: basic checks"
 	depends on DEBUG_KERNEL
+	select UNINLINE_SPIN_UNLOCK
 	help
 	  Say Y here and build SMP to catch missing spinlock initialization
 	  and certain other kinds of spinlock errors commonly made.  This is
