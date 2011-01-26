Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1AZLAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:00:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab1AZLAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:00:17 -0500
Date: Wed, 26 Jan 2011 10:59:33 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, bp@alien8.de, suresh.b.siddha@intel.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@elte.hu
In-Reply-To: <4D3A16F2.5090902@kernel.org>
References: <4D3A16F2.5090902@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Don't copy per_cpu cpuinfo for BSP two times
Message-ID: <tip-792363d2beceb1c7d865e517fa9939c8b8c1442a@git.kernel.org>
Git-Commit-ID: 792363d2beceb1c7d865e517fa9939c8b8c1442a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 10:59:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  792363d2beceb1c7d865e517fa9939c8b8c1442a
Gitweb:     http://git.kernel.org/tip/792363d2beceb1c7d865e517fa9939c8b8c1442a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 21 Jan 2011 15:29:54 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:44:50 +0100

x86: Don't copy per_cpu cpuinfo for BSP two times

smp_store_cpu_info(0) will do that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
LKML-Reference: <4D3A16F2.5090902@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d396155..a7a3d1a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1071,13 +1071,13 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
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
