Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1GUUwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:52:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:57663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1GUUwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:52:17 -0400
Date: Thu, 21 Jul 2011 20:52:07 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-ae7bd11b471931752e5609094ca0a49386590524@git.kernel.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, luto@mit.edu, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, luto@mit.edu, tglx@linutronix.de, tony.luck@intel.com
In-Reply-To: <4E288AA6.7090804@zytor.com>
References: <4E288AA6.7090804@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] clocksource: Change __ARCH_HAS_CLOCKSOURCE_DATA to a CONFIG option
Git-Commit-ID: ae7bd11b471931752e5609094ca0a49386590524
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 20:52:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae7bd11b471931752e5609094ca0a49386590524
Gitweb:     http://git.kernel.org/tip/ae7bd11b471931752e5609094ca0a49386590524
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 21 Jul 2011 13:34:05 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Jul 2011 13:34:05 -0700

clocksource: Change __ARCH_HAS_CLOCKSOURCE_DATA to a CONFIG option

The machinery for __ARCH_HAS_CLOCKSOURCE_DATA assumed a file in
asm-generic would be the default for architectures without their own
file in asm/, but that is not how it works.

Replace it with a Kconfig option instead.

Link: http://lkml.kernel.org/r/4E288AA6.7090804@zytor.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/Kconfig                   |    3 +++
 arch/ia64/include/asm/clocksource.h |    2 --
 arch/x86/Kconfig                    |    4 ++++
 arch/x86/include/asm/clocksource.h  |    2 --
 include/asm-generic/clocksource.h   |    4 ----
 include/linux/clocksource.h         |    4 +++-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 38280ef..0a9820a 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -101,6 +101,9 @@ config GENERIC_IOMAP
 	bool
 	default y
 
+config ARCH_CLOCKSOURCE_DATA
+	def_bool y
+
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
diff --git a/arch/ia64/include/asm/clocksource.h b/arch/ia64/include/asm/clocksource.h
index 00eb549..5c8596e 100644
--- a/arch/ia64/include/asm/clocksource.h
+++ b/arch/ia64/include/asm/clocksource.h
@@ -3,8 +3,6 @@
 #ifndef _ASM_IA64_CLOCKSOURCE_H
 #define _ASM_IA64_CLOCKSOURCE_H
 
-#define __ARCH_HAS_CLOCKSOURCE_DATA
-
 struct arch_clocksource_data {
 	void *fsys_mmio;        /* used by fsyscall asm code */
 };
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..c1e41bc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,6 +93,10 @@ config CLOCKSOURCE_WATCHDOG
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
+config ARCH_CLOCKSOURCE_DATA
+	def_bool y
+	depends on X86_64
+
 config GENERIC_CLOCKEVENTS_BROADCAST
 	def_bool y
 	depends on X86_64 || (X86_32 && X86_LOCAL_APIC)
diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
index 3882c65..0bdbbb3 100644
--- a/arch/x86/include/asm/clocksource.h
+++ b/arch/x86/include/asm/clocksource.h
@@ -5,8 +5,6 @@
 
 #ifdef CONFIG_X86_64
 
-#define __ARCH_HAS_CLOCKSOURCE_DATA
-
 #define VCLOCK_NONE 0  /* No vDSO clock available.	*/
 #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
 #define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
diff --git a/include/asm-generic/clocksource.h b/include/asm-generic/clocksource.h
deleted file mode 100644
index 0a462d3..0000000
--- a/include/asm-generic/clocksource.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/*
- * Architectures should override this file to add private userspace
- * clock magic if needed.
- */
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 6bb6970..59ee970 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -22,7 +22,9 @@
 typedef u64 cycle_t;
 struct clocksource;
 
+#ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 #include <asm/clocksource.h>
+#endif
 
 /**
  * struct cyclecounter - hardware abstraction for a free running counter
@@ -171,7 +173,7 @@ struct clocksource {
 	u32 shift;
 	u64 max_idle_ns;
 
-#ifdef __ARCH_HAS_CLOCKSOURCE_DATA
+#ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
 #endif
 
