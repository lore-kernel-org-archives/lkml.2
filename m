Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2JHMHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:07:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49431 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JHMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:07:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,553,1344211200"; 
   d="scan'208";a="210578340"
From: David Vrabel <david.vrabel@citrix.com>
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, David Vrabel <david.vrabel@citrix.com>
Subject: [PATCHv2] x86: allow tracing of functions in arch/x86/kernel/rtc.c
Date: Mon, 8 Oct 2012 13:07:30 +0100
Message-ID: <1349698050-6560-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1349435895-21269-1-git-send-email-david.vrabel@citrix.com>
References: <1349435895-21269-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move native_read_tsc() to tsc.c to allow profiling to be re-enabled
for rtc.c.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
Changes in v2:
- re-add EXPORT_SYMBOL().
---
 arch/x86/kernel/Makefile |    1 -
 arch/x86/kernel/rtc.c    |    6 ------
 arch/x86/kernel/tsc.c    |    6 ++++++
 3 files changed, 6 insertions(+), 7 deletions(-)

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
-- 
1.7.2.5

