Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1BCArO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:14 -0500
Received: from www.tglx.de ([62.245.132.106]:37604 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab1BCArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:12 -0500
Message-Id: <20110203004210.045781831@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 1/8] frv:  Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=frv-remove-stale-irq-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ().

irq-mb93093.c even lacks an implementation, but nobody noticed that
it's broken since commit 88d6e1 in 2006.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/irq-mb93093.c |    1 -
 arch/frv/kernel/irq.c         |    6 ------
 2 files changed, 7 deletions(-)

Index: linux-2.6-tip/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-2.6-tip.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-2.6-tip/arch/frv/kernel/irq-mb93093.c
@@ -73,7 +73,6 @@ static struct irq_chip frv_fpga_pic = {
 	.mask		= frv_fpga_mask,
 	.mask_ack	= frv_fpga_mask_ack,
 	.unmask		= frv_fpga_unmask,
-	.end		= frv_fpga_end,
 };
 
 /*
Index: linux-2.6-tip/arch/frv/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/frv/kernel/irq.c
+++ linux-2.6-tip/arch/frv/kernel/irq.c
@@ -118,18 +118,12 @@ static void frv_cpupic_unmask(unsigned i
 	__clr_MASK(irqlevel);
 }
 
-static void frv_cpupic_end(unsigned int irqlevel)
-{
-	__clr_MASK(irqlevel);
-}
-
 static struct irq_chip frv_cpu_pic = {
 	.name		= "cpu",
 	.ack		= frv_cpupic_ack,
 	.mask		= frv_cpupic_mask,
 	.mask_ack	= frv_cpupic_mask_ack,
 	.unmask		= frv_cpupic_unmask,
-	.end		= frv_cpupic_end,
 };
 
 /*


