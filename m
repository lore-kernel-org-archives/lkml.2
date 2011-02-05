Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1BETpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:45:33 -0500
Received: from www.tglx.de ([62.245.132.106]:60131 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab1BETpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:45:30 -0500
Message-Id: <20110205193904.102709613@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 19:45:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch 7/8] ia64: Convert lsapic to new irq_chip functions
References: <20110205193740.964969119@linutronix.de>
Content-Disposition: inline; filename=ia64-convert-lsapic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/kernel/irq_lsapic.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-next/arch/ia64/kernel/irq_lsapic.c
===================================================================
--- linux-next.orig/arch/ia64/kernel/irq_lsapic.c
+++ linux-next/arch/ia64/kernel/irq_lsapic.c
@@ -15,30 +15,30 @@
 #include <linux/irq.h>
 
 static unsigned int
-lsapic_noop_startup (unsigned int irq)
+lsapic_noop_startup (struct irq_data *data)
 {
 	return 0;
 }
 
 static void
-lsapic_noop (unsigned int irq)
+lsapic_noop (struct irq_data *data)
 {
 	/* nothing to do... */
 }
 
-static int lsapic_retrigger(unsigned int irq)
+static int lsapic_retrigger(struct irq_data *data)
 {
-	ia64_resend_irq(irq);
+	ia64_resend_irq(data->irq);
 
 	return 1;
 }
 
 struct irq_chip irq_type_ia64_lsapic = {
-	.name =		"LSAPIC",
-	.startup =	lsapic_noop_startup,
-	.shutdown =	lsapic_noop,
-	.enable =	lsapic_noop,
-	.disable =	lsapic_noop,
-	.ack =		lsapic_noop,
-	.retrigger =	lsapic_retrigger,
+	.name =			"LSAPIC",
+	.irq_startup =		lsapic_noop_startup,
+	.irq_shutdown =		lsapic_noop,
+	.irq_enable =		lsapic_noop,
+	.irq_disable =		lsapic_noop,
+	.irq_ack =		lsapic_noop,
+	.irq_retrigger =	lsapic_retrigger,
 };


