Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2E3NgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:36:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2E3NgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:36:00 -0400
Date: Wed, 30 May 2012 06:35:23 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-lsksc2kfyeveb13avh327p0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        bp@amd64.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, andreas.herrmann3@amd.com, efault@gmx.de,
        tglx@linutronix.de, bp@amd64.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/x86: Use cpu_llc_shared_mask(cpu)
  for coregroup_mask
Git-Commit-ID: 9f646389aa7727a2fd8f9ae6337b92af9cfbc264
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:35:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f646389aa7727a2fd8f9ae6337b92af9cfbc264
Gitweb:     http://git.kernel.org/tip/9f646389aa7727a2fd8f9ae6337b92af9cfbc264
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 29 May 2012 16:39:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 11:05:44 +0200

sched/x86: Use cpu_llc_shared_mask(cpu) for coregroup_mask

Commit commit 8e7fbcbc2 ("sched: Remove stale power aware scheduling
remnants and dysfunctional knobs") made a boo-boo with removing the
power aware scheduling muck from the x86 topology bits.

We should unconditionally use the llc_shared mask for multi-core.

Reported-and-tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/n/tip-lsksc2kfyeveb13avh327p0d@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f56f96d..fd019d7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -410,15 +410,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 /* maps the cpu to the sched domain representing multi-core */
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	/*
-	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
-	 */
-	if (!(cpu_has(c, X86_FEATURE_AMD_DCM)))
-		return cpu_core_mask(cpu);
-	else
-		return cpu_llc_shared_mask(cpu);
+	return cpu_llc_shared_mask(cpu);
 }
 
 static void impress_friends(void)
