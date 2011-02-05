Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1BETo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:44:59 -0500
Received: from www.tglx.de ([62.245.132.106]:60068 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1BETo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:44:57 -0500
Message-Id: <20110205193903.615488461@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 19:44:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch 2/8] ia64: Convert hp-sim to new irq_chip functions
References: <20110205193740.964969119@linutronix.de>
Content-Disposition: inline; filename=ia64-convert-hp-sim.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/hp/sim/hpsim_irq.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-next/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-next.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-next/arch/ia64/hp/sim/hpsim_irq.c
@@ -11,30 +11,30 @@
 #include <linux/irq.h>
 
 static unsigned int
-hpsim_irq_startup (unsigned int irq)
+hpsim_irq_startup(struct irq_data *data)
 {
 	return 0;
 }
 
 static void
-hpsim_irq_noop (unsigned int irq)
+hpsim_irq_noop(struct irq_data *data)
 {
 }
 
 static int
-hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
+hpsim_set_affinity_noop(struct irq_data *d, const struct cpumask *b, bool f)
 {
 	return 0;
 }
 
 static struct irq_chip irq_type_hp_sim = {
-	.name =		"hpsim",
-	.startup =	hpsim_irq_startup,
-	.shutdown =	hpsim_irq_noop,
-	.enable =	hpsim_irq_noop,
-	.disable =	hpsim_irq_noop,
-	.ack =		hpsim_irq_noop,
-	.set_affinity =	hpsim_set_affinity_noop,
+	.name =			"hpsim",
+	.irq_startup =		hpsim_irq_startup,
+	.irq_shutdown =		hpsim_irq_noop,
+	.irq_enable =		hpsim_irq_noop,
+	.irq_disable =		hpsim_irq_noop,
+	.irq_ack =		hpsim_irq_noop,
+	.irq_set_affinity =	hpsim_set_affinity_noop,
 };
 
 void __init


