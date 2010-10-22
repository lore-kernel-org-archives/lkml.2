Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab0JVU72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:59:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:36316 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0JVU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:06 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 03/11] debug_core: stop rcu warnings on kernel resume
Date: Fri, 22 Oct 2010 15:56:23 -0500
Message-Id: <1287780991-7476-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:50.0237 (UTC) FILETIME=[A5E17ED0:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When returning from the kernel debugger reset the rcu jiffies_stall
value to prevent the rcu stall detector from sending NMI events which
invoke a stack dump for each cpu in the system.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index c812857..5a3b04d 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -47,6 +47,7 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/rcupdate.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -474,6 +475,7 @@ static void dbg_touch_watchdogs(void)
 {
 	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
+	rcu_cpu_stall_reset();
 }
 
 static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
-- 
1.6.3.3

