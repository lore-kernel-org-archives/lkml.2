Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2ECO5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:57:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45494 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2ECO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:57:32 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Subject: [PATCH v1 6/6] x86: make clocksource watchdog configurable (not for mainline)
Date: Thu,  3 May 2012 17:56:02 +0300
Message-Id: <1336056962-10465-7-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock source watchdog wakes up idle cores.

Since I'm using KVM to test, where the TSC is always marked
unstable, I've added this option to allow to disable it to
assist testing.

This is not intended for mainlining, the patch just serves
as a reference for how I tested the patch set.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tejun Heo <tj@kernel.org>
CC: John Stultz <johnstul@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Mike Frysinger <vapier@gentoo.org>
CC: David Rientjes <rientjes@google.com>
CC: Hugh Dickins <hughd@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Christoph Lameter <cl@linux.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Hakan Akkan <hakanakkan@gmail.com>
CC: Max Krasnyansky <maxk@qualcomm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org
---
 arch/x86/Kconfig          |    9 ++++++---
 kernel/time/clocksource.c |    2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..6706c00 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -99,9 +99,6 @@ config ARCH_DEFCONFIG
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
-config CLOCKSOURCE_WATCHDOG
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
@@ -1673,6 +1670,12 @@ config HOTPLUG_CPU
 	    automatically on SMP systems. )
 	  Say N if you want to disable CPU hotplug.
 
+config CLOCKSOURCE_WATCHDOG
+	bool "Clocksource watchdog"
+	default y
+	help
+	  Enable clock source watchdog.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..1eb5a4e 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -450,6 +450,8 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+void clocksource_mark_unstable(struct clocksource *cs) { }
+
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
-- 
1.7.0.4

