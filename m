Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2JELSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:18:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17438 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JELSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:18:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,541,1344211200"; 
   d="scan'208";a="210399049"
From: David Vrabel <david.vrabel@citrix.com>
To: x86@kernel.org
CC: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] x86: allow tracing of functions in arch/x86/kernel/rtc.c
Date: Fri, 5 Oct 2012 12:18:15 +0100
Message-ID: <1349435895-21269-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move native_read_tsc() to tsc.c to allow profiling to be re-enabled
for rtc.c.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/kernel/Makefile |    1 -
 arch/x86/kernel/rtc.c    |    6 ------
 arch/x86/kernel/tsc.c    |    5 +++++
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8215e56..19dd3a6 100644
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
index af6db6e..8ab7c62 100644
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
index cfa5d4f..15e190a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -77,6 +77,11 @@ unsigned long long
 sched_clock(void) __attribute__((alias("native_sched_clock")));
 #endif
 
+unsigned long long native_read_tsc(void)
+{
+	return __native_read_tsc();
+}
+
 int check_tsc_unstable(void)
 {
 	return tsc_unstable;
-- 
1.7.2.5

