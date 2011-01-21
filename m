Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1AUXb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:31:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18118 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1AUXb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:31:58 -0500
Message-ID: <4D3A16F2.5090902@kernel.org>
Date: Fri, 21 Jan 2011 15:29:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Don't copy per_cpu cpuinfo for BSP two times
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


smp_store_cpu_info(0) will do that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/smpboot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1071,13 +1071,13 @@ void __init native_smp_prepare_cpus(unsi
 
 	preempt_disable();
 	smp_cpu_index_default();
-	memcpy(__this_cpu_ptr(&cpu_info), &boot_cpu_data, sizeof(cpu_info));
-	cpumask_copy(cpu_callin_mask, cpumask_of(0));
-	mb();
+
 	/*
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
+	cpumask_copy(cpu_callin_mask, cpumask_of(0));
+	mb();
 #ifdef CONFIG_X86_32
 	boot_cpu_logical_apicid = logical_smp_processor_id();
 #endif
