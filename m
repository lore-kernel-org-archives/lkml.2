Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0KVJlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:41:31 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:53093 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab0KVJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:41:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 1/1] IA64: irq_ia64, use set_irq_chip
Date: Mon, 22 Nov 2010 10:41:19 +0100
Message-Id: <1290418879-4079-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access desc->chip directly, because them chip member will
disappear some time later.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/kernel/irq_ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 9a26015..38c07b8 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -633,7 +633,7 @@ ia64_native_register_percpu_irq (ia64_vector vec, struct irqaction *action)
 	BUG_ON(bind_irq_vector(irq, vec, CPU_MASK_ALL));
 	desc = irq_desc + irq;
 	desc->status |= IRQ_PER_CPU;
-	desc->chip = &irq_type_ia64_lsapic;
+	set_irq_chip(irq, &irq_type_ia64_lsapic);
 	if (action)
 		setup_irq(irq, action);
 	set_irq_handler(irq, handle_percpu_irq);
-- 
1.7.3.1


