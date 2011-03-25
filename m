Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1CYNWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:34647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609Ab1CYNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:04 -0400
Message-Id: <20110325132048.513694292@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 12/23] arm: vt8500: Use proper irq accessors
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-vt8500.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-vt8500/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-vt8500/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-vt8500/irq.c
+++ linux-2.6-tip/arch/arm/mach-vt8500/irq.c
@@ -97,15 +97,15 @@ static int vt8500_irq_set_type(unsigned 
 		return -EINVAL;
 	case IRQF_TRIGGER_HIGH:
 		dctr |= VT8500_TRIGGER_HIGH;
-		irq_desc[orig_irq].handle_irq = handle_level_irq;
+		__irq_set_handler_locked(orig_irq, handle_level_irq);
 		break;
 	case IRQF_TRIGGER_FALLING:
 		dctr |= VT8500_TRIGGER_FALLING;
-		irq_desc[orig_irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(orig_irq, handle_edge_irq);
 		break;
 	case IRQF_TRIGGER_RISING:
 		dctr |= VT8500_TRIGGER_RISING;
-		irq_desc[orig_irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(orig_irq, handle_edge_irq);
 		break;
 	}
 	writeb(dctr, base + VT8500_IC_DCTR + irq);


