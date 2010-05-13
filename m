Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab0EMBVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:21:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51999 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab0EMBV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=dC+qjq915+AuhVXLp72fRJzMA/ahom4cbd8Q5eU1DhaV47C59Sy+Y47OGFPnTSYFJ8
         8FL1MVxB9TTuI+hFZi80u/OmFCSV3hXZv9E234xlhk9bJIYJGxdFQHGNiuctSKIwFT2H
         WkVj680lrgyWPEgWCscf5d8mGWA4er3plPNOs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 9/9] lockup_detector: Fix forgotten config conversion
Date: Thu, 13 May 2010 03:21:14 +0200
Message-Id: <1273713674-8434-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix forgotten CONFIG_DETECT_SOFTLOCKUP -> CONFIG_LOCKUP_DETECTOR
in sched.h

Fixes:
	arch/x86/built-in.o: In function `touch_nmi_watchdog':
	(.text+0x1bd59): undefined reference to `touch_softlockup_watchdog'
	kernel/built-in.o: In function `show_state_filter':
	(.text+0x10d01): undefined reference to `touch_all_softlockup_watchdogs'
	kernel/built-in.o: In function `sched_clock_idle_wakeup_event':
	(.text+0x362f9): undefined reference to `touch_softlockup_watchdog'
	kernel/built-in.o: In function `timekeeping_resume':
	timekeeping.c:(.text+0x38757): undefined reference to `touch_softlockup_watchdog'
	kernel/built-in.o: In function `tick_nohz_handler':
	tick-sched.c:(.text+0x3e5b9): undefined reference to `touch_softlockup_watchdog'
	kernel/built-in.o: In function `tick_sched_timer':
	tick-sched.c:(.text+0x3e671): undefined reference to `touch_softlockup_watchdog'
	kernel/built-in.o: In function `tick_check_idle':
	(.text+0x3e90b): undefined reference to `touch_softlockup_watchdog'

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33f9b2a..3958e0c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -311,7 +311,7 @@ extern void scheduler_tick(void);
 
 extern void sched_show_task(struct task_struct *p);
 
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
-- 
1.6.2.3

