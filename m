Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0IAGZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:25:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:47989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0IAGZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:25:36 -0400
Date: Wed, 1 Sep 2010 06:25:05 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akinobu.mita@gmail.com, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1283310009-22168-4-git-send-email-dzickus@redhat.com>
References: <1283310009-22168-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] lockup_detector: Remove unused panic_notifier
Message-ID: <tip-14416c35b6b9975c9593d7ecc8382d1ecaa0b598@git.kernel.org>
Git-Commit-ID: 14416c35b6b9975c9593d7ecc8382d1ecaa0b598
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Sep 2010 06:25:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14416c35b6b9975c9593d7ecc8382d1ecaa0b598
Gitweb:     http://git.kernel.org/tip/14416c35b6b9975c9593d7ecc8382d1ecaa0b598
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Tue, 31 Aug 2010 23:00:09 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Sep 2010 07:33:34 +0200

lockup_detector: Remove unused panic_notifier

The panic notifer in lockup_detector just set did_panic to 1.
But did_panic is not used anywhere so we can just remove it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: fweisbec@gmail.com
LKML-Reference: <1283310009-22168-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 501cb6e..5b1ee4f4 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -43,7 +43,6 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int __read_mostly did_panic;
 static int __initdata no_watchdog;
 
 
@@ -180,18 +179,6 @@ static int is_softlockup(unsigned long touch_ts)
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
@@ -564,8 +551,6 @@ static int __init spawn_watchdog_task(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
-
 	return 0;
 }
 early_initcall(spawn_watchdog_task);
