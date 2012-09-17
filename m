Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2IQWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:05:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43871 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab2IQWFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:05:21 -0400
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
Subject: [PATCH 2/6][RFC] time: Move update_vsyscall definitions to timekeeper_internal.h
Date: Mon, 17 Sep 2012 18:04:57 -0400
Message-Id: <1347919501-64534-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091722-7182-0000-0000-000002A5608D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since users will need to include timekeeper_internal.h, move
update_vsyscall definitions to timekeeper_internal.h.

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
 arch/ia64/kernel/time.c             |    2 +-
 arch/powerpc/kernel/time.c          |    2 +-
 arch/s390/kernel/time.c             |    2 +-
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 include/linux/clocksource.h         |   16 ----------------
 include/linux/timekeeper_internal.h |   17 +++++++++++++++++
 kernel/time.c                       |    2 +-
 7 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index ecc904b..acb688f 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/efi.h>
 #include <linux/timex.h>
-#include <linux/clocksource.h>
+#include <linux/timekeeper_internal.h>
 #include <linux/platform_device.h>
 
 #include <asm/machvec.h>
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e49e931..613a830d 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -73,7 +73,7 @@
 /* powerpc clocksource/clockevent code */
 
 #include <linux/clockchips.h>
-#include <linux/clocksource.h>
+#include <linux/timekeeper_internal.h>
 
 static cycle_t rtc_read(struct clocksource *);
 static struct clocksource clocksource_rtc = {
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index dcec960..bfb62ad 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -34,7 +34,7 @@
 #include <linux/profile.h>
 #include <linux/timex.h>
 #include <linux/notifier.h>
-#include <linux/clocksource.h>
+#include <linux/timekeeper_internal.h>
 #include <linux/clockchips.h>
 #include <linux/gfp.h>
 #include <linux/kprobes.h>
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8d141b3..6ec8411 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -28,7 +28,7 @@
 #include <linux/jiffies.h>
 #include <linux/sysctl.h>
 #include <linux/topology.h>
-#include <linux/clocksource.h>
+#include <linux/timekeeper_internal.h>
 #include <linux/getcpu.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index fbe89e1..4dceaf8 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -319,22 +319,6 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 	__clocksource_updatefreq_scale(cs, 1000, khz);
 }
 
-#ifdef CONFIG_GENERIC_TIME_VSYSCALL
-extern void
-update_vsyscall(struct timespec *ts, struct timespec *wtm,
-			struct clocksource *c, u32 mult);
-extern void update_vsyscall_tz(void);
-#else
-static inline void
-update_vsyscall(struct timespec *ts, struct timespec *wtm,
-			struct clocksource *c, u32 mult)
-{
-}
-
-static inline void update_vsyscall_tz(void)
-{
-}
-#endif
 
 extern void timekeeping_notify(struct clocksource *clock);
 
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 8ba43fa..9c1c2cf 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -65,4 +65,21 @@ struct timekeeper {
 	/* Seqlock for all timekeeper values */
 	seqlock_t		lock;
 };
+
+
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL
+extern void
+update_vsyscall(struct timespec *ts, struct timespec *wtm,
+			struct clocksource *c, u32 mult);
+extern void update_vsyscall_tz(void);
+#else
+static inline void update_vsyscall(struct timespec *ts, struct timespec *wtm,
+					struct clocksource *c, u32 mult)
+{
+}
+static inline void update_vsyscall_tz(void)
+{
+}
+#endif
+
 #endif /* _LINUX_TIMEKEEPER_INTERNAL_H */
diff --git a/kernel/time.c b/kernel/time.c
index ba744cf..d226c6a 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -30,7 +30,7 @@
 #include <linux/export.h>
 #include <linux/timex.h>
 #include <linux/capability.h>
-#include <linux/clocksource.h>
+#include <linux/timekeeper_internal.h>
 #include <linux/errno.h>
 #include <linux/syscalls.h>
 #include <linux/security.h>
-- 
1.7.9.5

