Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0HUJuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:50:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57008 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0HUJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tCUD+4Z3HsPHw100m8tksRtu3GVu8hYJTT5lHYhiUApSuDH49Sv4CZG1w40guQpaSL
         nm7XZiSOkt/e+ueh8lbJ8CKf3Rx+RO85qvORdJwyHjiO/x9gCzoFWNFurK4hR1VaG0bL
         0Sg6rqyi2GCTY9pjWeTRip3yGNnCX93BRWqfc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] lockup_detector: remove unnecessary panic_notifier
Date: Sat, 21 Aug 2010 18:43:47 +0900
Message-Id: <1282383827-12064-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1282383827-12064-1-git-send-email-akinobu.mita@gmail.com>
References: <1282383827-12064-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic notifer in lockup_detector just set did_panic to 1.
But did_panic is not used anywhere so we can just remove it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index de98f77..1ff0b8c 100644
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
@@ -561,8 +548,6 @@ static int __init spawn_watchdog_task(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
-
 	return 0;
 }
 early_initcall(spawn_watchdog_task);
-- 
1.6.0.6

