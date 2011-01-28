Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1A1Oh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:37:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:59923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab1A1Oh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:37:58 -0500
Date: Fri, 28 Jan 2011 14:37:09 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-2-git-send-email-tj@kernel.org>
References: <1295789862-25482-2-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Kill unused static boot_cpu_logical_apicid in smpboot.c
Message-ID: <tip-bd22a2f1982fa3e90ce7d5d011c37d88aa67e73c@git.kernel.org>
Git-Commit-ID: bd22a2f1982fa3e90ce7d5d011c37d88aa67e73c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:37:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd22a2f1982fa3e90ce7d5d011c37d88aa67e73c
Gitweb:     http://git.kernel.org/tip/bd22a2f1982fa3e90ce7d5d011c37d88aa67e73c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:04 +0100

x86: Kill unused static boot_cpu_logical_apicid in smpboot.c

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-2-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0cbe8c0..ee9203a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -165,8 +165,6 @@ static void unmap_cpu_to_node(int cpu)
 #endif
 
 #ifdef CONFIG_X86_32
-static int boot_cpu_logical_apicid;
-
 u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
 					{ [0 ... NR_CPUS-1] = BAD_APICID };
 
@@ -1096,9 +1094,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
-#ifdef CONFIG_X86_32
-	boot_cpu_logical_apicid = logical_smp_processor_id();
-#endif
+
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
