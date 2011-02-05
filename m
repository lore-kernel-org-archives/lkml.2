Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1BETpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:45:00 -0500
Received: from www.tglx.de ([62.245.132.106]:60076 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1BETo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:44:59 -0500
Message-Id: <20110205193903.711620226@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 19:44:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch 3/8] ia64: hp-sim: Cleanup direct access to irq_desc
References: <20110205193740.964969119@linutronix.de>
Content-Disposition: inline; filename=ia64-hp-sim-use-accessor-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use accessor functions instead of open coded access.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/hp/sim/hpsim_irq.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-next/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-next.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-next/arch/ia64/hp/sim/hpsim_irq.c
@@ -40,12 +40,12 @@ static struct irq_chip irq_type_hp_sim =
 void __init
 hpsim_irq_init (void)
 {
-	struct irq_desc *idesc;
 	int i;
 
-	for (i = 0; i < NR_IRQS; ++i) {
-		idesc = irq_desc + i;
-		if (idesc->chip == &no_irq_chip)
-			idesc->chip = &irq_type_hp_sim;
+	for_each_active_irq(i) {
+		struct irq_chip *chip = get_irq_chip(i);
+
+		if (chip == &no_irq_chip)
+			set_irq_chip(i, &irq_type_hp_sim);
 	}
 }


