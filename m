Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0IADAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 23:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0IADA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 23:00:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] lockup_detector: remove unnecessary panic_notifier
Date: Tue, 31 Aug 2010 23:00:09 -0400
Message-Id: <1283310009-22168-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
References: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

The panic notifer in lockup_detector just set did_panic to 1.
But did_panic is not used anywhere so we can just remove it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index db70647..fa71aeb 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -43,7 +43,6 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int __read_mostly did_panic;
 static int __initdata no_watchdog;
 
 
@@ -187,18 +186,6 @@ static int is_softlockup(unsigned long touch_ts)
 	return 0;
 }
 
-static int
-watchdog_panic(struct notifier_block *this, unsigned long event, void *ptr)
-{
-	did_panic = 1;
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block panic_block = {
-	.notifier_call = watchdog_panic,
-};
-
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
@@ -571,8 +558,6 @@ static int __init spawn_watchdog_task(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
-
 	return 0;
 }
 early_initcall(spawn_watchdog_task);
-- 
1.7.2.2

