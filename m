Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab2JXNBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:01:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2JXNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:01:47 -0400
Date: Wed, 24 Oct 2012 06:00:23 -0700
From: tip-bot for David Vrabel <david.vrabel@citrix.com>
Message-ID: <tip-ce37f400336a34bb6e72c4700f9dcc2a41ff7163@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1349698050-6560-1-git-send-email-david.vrabel@citrix.com>
References: <1349698050-6560-1-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Allow tracing of functions in arch/x86/kernel
 /rtc.c
Git-Commit-ID: ce37f400336a34bb6e72c4700f9dcc2a41ff7163
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 06:00:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce37f400336a34bb6e72c4700f9dcc2a41ff7163
Gitweb:     http://git.kernel.org/tip/ce37f400336a34bb6e72c4700f9dcc2a41ff7163
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Mon, 8 Oct 2012 13:07:30 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 13:14:22 +0200

x86: Allow tracing of functions in arch/x86/kernel/rtc.c

Move native_read_tsc() to tsc.c to allow profiling to be
re-enabled for rtc.c.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1349698050-6560-1-git-send-email-david.vrabel@citrix.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/Makefile |    1 -
 arch/x86/kernel/rtc.c    |    6 ------
 arch/x86/kernel/tsc.c    |    6 ++++++
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 91ce48f..9fd5eed 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -9,7 +9,6 @@ CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_tsc.o = -pg
-CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 4929c1b..801602b 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -195,12 +195,6 @@ void read_persistent_clock(struct timespec *ts)
 	ts->tv_nsec = 0;
 }
 
-unsigned long long native_read_tsc(void)
-{
-	return __native_read_tsc();
-}
-EXPORT_SYMBOL(native_read_tsc);
-
 
 static struct resource rtc_resources[] = {
 	[0] = {
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..06ccb50 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -77,6 +77,12 @@ unsigned long long
 sched_clock(void) __attribute__((alias("native_sched_clock")));
 #endif
 
+unsigned long long native_read_tsc(void)
+{
+	return __native_read_tsc();
+}
+EXPORT_SYMBOL(native_read_tsc);
+
 int check_tsc_unstable(void)
 {
 	return tsc_unstable;
