Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0CXL7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:59:47 -0400
Received: from server78.greatnet.de ([83.133.96.102]:60726 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0CXL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:59:45 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: henne@nachtwindheim.de
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] IRQ: move two IRQ functions from .init.text to .text
Date: Wed, 24 Mar 2010 12:59:20 +0100
Message-Id: <1269431961-5731-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions should not be marked as __init, since they can
try to be called from modules after the init section is freed.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 kernel/irq/chip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 42ec11b..22a0168 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -716,7 +716,7 @@ set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 	__set_irq_handler(irq, handle, 0, name);
 }
 
-void __init set_irq_noprobe(unsigned int irq)
+void set_irq_noprobe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -731,7 +731,7 @@ void __init set_irq_noprobe(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-void __init set_irq_probe(unsigned int irq)
+void set_irq_probe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
-- 
1.6.3.3

