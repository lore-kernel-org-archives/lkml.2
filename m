Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1BQPxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:53:38 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:57812 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab1BQPxh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 17 Feb 2011 10:53:37 -0500
Message-Id: <4D5D52C2020000780003272C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 15:54:26 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend #2] x86: eliminate pointless adjustment
	 attempts in fixup_irqs()
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

--- 2.6.38-rc5/arch/x86/kernel/irq.c
+++ 2.6.38-rc5-x86-reduce-fixup-irqs/arch/x86/kernel/irq.c
@@ -310,7 +310,7 @@ void fixup_irqs(void)
 		data = &desc->irq_data;
 		affinity = data->affinity;
 		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
+		    cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}



