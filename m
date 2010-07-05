Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0GEKcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:32:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49524 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0GEKcP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 5 Jul 2010 06:32:15 -0400
Message-Id: <4C31D0C70200007800009863@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 05 Jul 2010 11:32:07 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: eliminate pointless adjustment attempts in
	 fixup_irqs()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not only when an IRQ's affinity equals cpu_online_mask is there no
need to actually try to adjust the affinity, but also when it's a
subset thereof. This particularly avoids adjustment attempts during
system shutdown to any IRQs bound to CPU#0.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-rc4/arch/x86/kernel/irq.c	2010-02-24 19:52:17.000000000 +0100
+++ 2.6.35-rc4-x86-reduce-irq-fixup/arch/x86/kernel/irq.c	2010-07-05 10:20:16.000000000 +0200
@@ -298,7 +298,7 @@ void fixup_irqs(void)
 
 		affinity = desc->affinity;
 		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
+		    cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}



