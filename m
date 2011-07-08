Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1GHSqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:46:45 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1376 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1GHSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:46:43 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Message-Id: <20110708184603.2734.91071.sendpatchset@nchumbalkar.americas.cpqcorp.net>
In-Reply-To: <20110708184557.2734.61830.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110708184557.2734.61830.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH 2/2] x86: Print Dest Field also
Date: Fri,  8 Jul 2011 18:46:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in setup_ioapic_irq() determines the Destination Field, so why not also
include it in the debug printk output that gets displayed when the boot parameter
"apic=debug" is used.

Before the fix, "dmesg" will show:
IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
...

After the fix, you will see:
IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
...

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ed4abaa..5cba200 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1337,9 +1337,9 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
-		    "IRQ %d Mode:%i Active:%i)\n",
+		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
 		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
-		    irq, trigger, polarity);
+		    irq, trigger, polarity, dest);
 
 
 	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
-- 
1.7.1

