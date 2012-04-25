Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab2DYDGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:06:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758156Ab2DYDGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:06:32 -0400
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 25 Apr 2012 13:05:24 +1000
Subject: [PATCH 1/3] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC
 interrupts.
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Message-ID: <20120425030524.7832.52047.stgit@notabene.brown>
In-Reply-To: <20120425025637.7832.14013.stgit@notabene.brown>
References: <20120425025637.7832.14013.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All interrupts can wake-from-sleep (I think) so it should be
permissible to call enable_irq_wake().  Setting this flag allows that.

It is needed because without this, an interrupt which is delivered
during late suspend will get ignored but will not cause suspend to
abort.
If enable_irq_wake() is called and succeeds, check_wakuep_irqs()
will abort the suspend if the interrupt has fired.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 arch/arm/mach-omap2/irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 65f0d257..b0790a9 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -148,6 +148,7 @@ omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 	ct->chip.irq_ack = omap_mask_ack_irq;
 	ct->chip.irq_mask = irq_gc_mask_disable_reg;
 	ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
+	ct->chip.flags |= IRQCHIP_SKIP_SET_WAKE;
 
 	ct->regs.ack = INTC_CONTROL;
 	ct->regs.enable = INTC_MIR_CLEAR0;


