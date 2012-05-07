Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2EGR7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:59:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:41385 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2EGR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:49 -0400
Message-Id: <20120507175652.119842173@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 3/8] cpuidle: Use kick_all_cpus_sync()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=cpuidle-use-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kick_all_cpus_sync() is the core implementation of cpu_idle_wait()
which is copied all over the arch code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/cpuidle/cpuidle.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: tip/drivers/cpuidle/cpuidle.c
===================================================================
--- tip.orig/drivers/cpuidle/cpuidle.c
+++ tip/drivers/cpuidle/cpuidle.c
@@ -40,17 +40,6 @@ void disable_cpuidle(void)
 	off = 1;
 }
 
-#if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
-static void cpuidle_kick_cpus(void)
-{
-	cpu_idle_wait();
-}
-#elif defined(CONFIG_SMP)
-# error "Arch needs cpu_idle_wait() equivalent here"
-#else /* !CONFIG_ARCH_HAS_CPU_IDLE_WAIT && !CONFIG_SMP */
-static void cpuidle_kick_cpus(void) {}
-#endif
-
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
 static inline int cpuidle_enter(struct cpuidle_device *dev,
@@ -186,7 +175,7 @@ void cpuidle_uninstall_idle_handler(void
 {
 	if (enabled_devices) {
 		initialized = 0;
-		cpuidle_kick_cpus();
+		kick_all_cpus_sync();
 	}
 }
 


