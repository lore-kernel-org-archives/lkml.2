Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab2FFV1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:27:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:52056 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2FFV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:27:15 -0400
Message-Id: <20120606212334.513459224@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:27:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/6] x86: mce: Create devices in CPU_UP_PREPARE
References: <20120606211746.693649684@linutronix.de>
Content-Disposition: inline; filename=x86-mce-cleanup-notifiers.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the treshold_cpu_callback for AMD actually work and makes
the code symetric vs. teardown.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: tip/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2256,8 +2256,8 @@ mce_cpu_callback(struct notifier_block *
 	struct timer_list *t = &per_cpu(mce_timer, cpu);
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mce_device_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);


