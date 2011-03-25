Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1CYNWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:34685 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752697Ab1CYNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:10 -0400
Message-Id: <20110325132049.091150005@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 18/23] arm: gic: Use proper accessor functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-gic.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/common/gic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/arch/arm/common/gic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/gic.c
+++ linux-2.6-tip/arch/arm/common/gic.c
@@ -382,7 +382,7 @@ void __cpuinit gic_enable_ppi(unsigned i
 	unsigned long flags;
 
 	local_irq_save(flags);
-	irq_to_desc(irq)->status |= IRQ_NOPROBE;
+	irq_set_status_flags(irq, IRQ_NOPROBE);
 	gic_unmask_irq(irq_get_irq_data(irq));
 	local_irq_restore(flags);
 }


