Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab1GKS7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:59:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:54922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab1GKS7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:59:14 -0400
Date: Mon, 11 Jul 2011 18:58:58 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Message-ID: <tip-7fece83235a59b15d75d6c8ef2225c24abd4505b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110708184603.2734.91071.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110708184603.2734.91071.sendpatchset@nchumbalkar.americas.cpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Also print Dest field
Git-Commit-ID: 7fece83235a59b15d75d6c8ef2225c24abd4505b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Jul 2011 18:58:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fece83235a59b15d75d6c8ef2225c24abd4505b
Gitweb:     http://git.kernel.org/tip/7fece83235a59b15d75d6c8ef2225c24abd4505b
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Fri, 8 Jul 2011 18:46:42 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Jul 2011 16:31:05 +0200

x86, ioapic: Also print Dest field

The code in setup_ioapic_irq() determines the Destination Field,
so why not also include it in the debug printk output that gets
displayed when the boot parameter "apic=debug" is used.

Before the change, "dmesg" will show:

 IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0) ...

After the change, you will see:

 IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
 IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
 IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0) ...

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Link: http://lkml.kernel.org/r/20110708184603.2734.91071.sendpatchset@nchumbalkar.americas.cpqcorp.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
