Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1GLF7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:59:09 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18030 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1GLF7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:59:08 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, suresh.b.siddha@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de
Message-Id: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE MSR
Date: Tue, 12 Jul 2011 05:59:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's no special reason to zero-out the "high" 32-bits of the IA32_APIC_BASE
MSR, let's preserve it.

The x2APIC Specification doesn't explicitly state any such requirement. (Sec 2.2 
in: http://www.intel.com/Assets/PDF/manual/318148.pdf).

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..f7b0c7a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1429,7 +1429,7 @@ void enable_x2apic(void)
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
