Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0I3XQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:16:49 -0400
Received: from www.tglx.de ([62.245.132.106]:52650 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab0I3XQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:16:44 -0400
Message-Id: <20100930221740.640417405@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 22/47] x86: lguest: Convert to new irq chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-convert-virt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lguest/boot.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/lguest/boot.c
+++ linux-2.6-tip/arch/x86/lguest/boot.c
@@ -788,22 +788,22 @@ static void lguest_flush_tlb_kernel(void
  * simple as setting a bit.  We don't actually "ack" interrupts as such, we
  * just mask and unmask them.  I wonder if we should be cleverer?
  */
-static void disable_lguest_irq(unsigned int irq)
+static void disable_lguest_irq(struct irq_data *data)
 {
-	set_bit(irq, lguest_data.blocked_interrupts);
+	set_bit(data->irq, lguest_data.blocked_interrupts);
 }
 
-static void enable_lguest_irq(unsigned int irq)
+static void enable_lguest_irq(struct irq_data *data)
 {
-	clear_bit(irq, lguest_data.blocked_interrupts);
+	clear_bit(data->irq, lguest_data.blocked_interrupts);
 }
 
 /* This structure describes the lguest IRQ controller. */
 static struct irq_chip lguest_irq_controller = {
 	.name		= "lguest",
-	.mask		= disable_lguest_irq,
-	.mask_ack	= disable_lguest_irq,
-	.unmask		= enable_lguest_irq,
+	.irq_mask	= disable_lguest_irq,
+	.irq_mask_ack	= disable_lguest_irq,
+	.irq_unmask	= enable_lguest_irq,
 };
 
 /*


