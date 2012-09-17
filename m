Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2IQWGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:06:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37564 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab2IQWF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:05:56 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Tony Luck <tony.luck@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6][RFC] time: Convert CONFIG_GENERIC_TIME_VSYSCALL to CONFIG_GENERIC_TIME_VSYSCALL_OLD
Date: Mon, 17 Sep 2012 18:04:58 -0400
Message-Id: <1347919501-64534-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091722-6078-0000-0000-00000FB0FCEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help migrate archtectures over to the new update_vsyscall method,
redfine CONFIG_GENERIC_TIME_VSYSCALL as CONFIG_GENERIC_TIME_VSYSCALL_OLD

Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/ia64/Kconfig                   |    2 +-
 arch/ia64/kernel/time.c             |    2 +-
 arch/powerpc/Kconfig                |    2 +-
 arch/powerpc/kernel/time.c          |    2 +-
 arch/s390/Kconfig                   |    2 +-
 arch/s390/kernel/time.c             |    2 +-
 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 include/linux/timekeeper_internal.h |    7 ++++---
 kernel/time/Kconfig                 |    2 +-
 kernel/time/timekeeping.c           |    2 +-
 11 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 310cf57..f9e673c 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -38,7 +38,7 @@ config IA64
 	select ARCH_TASK_STRUCT_ALLOCATOR
 	select ARCH_THREAD_INFO_ALLOCATOR
 	select ARCH_CLOCKSOURCE_DATA
-	select GENERIC_TIME_VSYSCALL
+	select GENERIC_TIME_VSYSCALL_OLD
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index acb688f..d2f4e26 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -454,7 +454,7 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct timespec *wtm,
+void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
 			struct clocksource *c, u32 mult)
 {
 	write_seqcount_begin(&fsyscall_gtod_data.seq);
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..0881660 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -135,7 +135,7 @@ config PPC
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
-	select GENERIC_TIME_VSYSCALL
+	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 613a830d..c825809 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -712,7 +712,7 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
 	u64 new_tb_to_xs, new_stamp_xsec;
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 107610e..ba488aa 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -121,7 +121,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_SMP_IDLE_THREAD
-	select GENERIC_TIME_VSYSCALL
+	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
 	select HAVE_ARCH_SECCOMP_FILTER
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index bfb62ad..c5430bf 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -219,7 +219,7 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
 	if (clock != &clocksource_tod)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..e3f3c1a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,7 +93,7 @@ config X86
 	select GENERIC_CLOCKEVENTS
 	select ARCH_CLOCKSOURCE_DATA if X86_64
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
-	select GENERIC_TIME_VSYSCALL if X86_64
+	select GENERIC_TIME_VSYSCALL_OLD if X86_64
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 6ec8411..77dde29 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -82,7 +82,7 @@ void update_vsyscall_tz(void)
 	vsyscall_gtod_data.sys_tz = sys_tz;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
 	struct timespec monotonic;
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 9c1c2cf..a904d76 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -67,13 +67,14 @@ struct timekeeper {
 };
 
 
-#ifdef CONFIG_GENERIC_TIME_VSYSCALL
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
 extern void
-update_vsyscall(struct timespec *ts, struct timespec *wtm,
+update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
 			struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
-static inline void update_vsyscall(struct timespec *ts, struct timespec *wtm,
+static inline void
+update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
 					struct clocksource *c, u32 mult)
 {
 }
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index fd42bd4..489c861 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -13,7 +13,7 @@ config ARCH_CLOCKSOURCE_DATA
 	bool
 
 # Timekeeping vsyscall support
-config GENERIC_TIME_VSYSCALL
+config GENERIC_TIME_VSYSCALL_OLD
 	bool
 
 # ktime_t scalar 64bit nsec representation
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 61f5fba..bdce688 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -199,7 +199,7 @@ static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 		ntp_clear();
 	}
 	xt = tk_xtime(tk);
-	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
+	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
 }
 
 /**
-- 
1.7.9.5

