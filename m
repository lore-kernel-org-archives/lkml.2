Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1DLHlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:41:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:59901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1DLHlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:41:11 -0400
Date: Tue, 12 Apr 2011 07:40:28 GMT
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <tip-3905c54f2bd2c6f937f87307987ca072eabc3e7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, davem@davemloft.net, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, davem@davemloft.net, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20110412140040.3020ef55.sfr@canb.auug.org.au>
References: <20110412140040.3020ef55.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched, sparc64: Turn cpu_coregroup_mask() into a real function
Git-Commit-ID: 3905c54f2bd2c6f937f87307987ca072eabc3e7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Apr 2011 07:40:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3905c54f2bd2c6f937f87307987ca072eabc3e7b
Gitweb:     http://git.kernel.org/tip/3905c54f2bd2c6f937f87307987ca072eabc3e7b
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Tue, 12 Apr 2011 14:00:40 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 Apr 2011 08:46:41 +0200

sched, sparc64: Turn cpu_coregroup_mask() into a real function

This compile error triggers on Sparc64:

   kernel/sched.c:7140: error: 'cpu_coregroup_mask' undeclared here (not in a function)

Because after the recent scheduler domain cleanups the scheduler
uses this arch method as a function pointer in a scheduler
topology data structure - which is not possible with a macro.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110412140040.3020ef55.sfr@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/sparc/include/asm/topology_64.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 1c79f32..8b9c556 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -65,6 +65,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
-#define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
+extern cpumask_t cpu_core_map[NR_CPUS];
+static inline const struct cpumask *cpu_coregroup_mask(int cpu)
+{
+        return &cpu_core_map[cpu];
+}
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */
