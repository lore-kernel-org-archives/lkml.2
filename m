Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1JGUEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:04:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33309 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab1JGUEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:04:33 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, kevin.tian@intel.com,
        fengzhe.zhang@intel.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH] x86: fix format in do_IRQ()
Date: Fri,  7 Oct 2011 22:03:59 +0200
Message-Id: <1318017839-10389-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq and vector are of type unsigned int, use %u instead of %d.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..7429a4a 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -189,7 +189,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 		ack_APIC_irq();
 
 		if (printk_ratelimit())
-			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
+			pr_emerg("%s: %d.%u No irq handler for vector (irq %u)\n",
 				__func__, smp_processor_id(), vector, irq);
 	}
 
-- 
1.7.7

