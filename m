Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1LFKsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:48:11 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45660 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1LFKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:48:09 -0500
Date: Tue, 6 Dec 2011 16:17:55 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: daniel@numascale-asia.com
Cc: mingo@elte.hu, sp@numascale.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH tip] Fix build failure x86_default_fixup_cpu_id() with
 !CONFIG_SMP
Message-ID: <20111206104755.GA8567@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120610-8878-0000-0000-00000079B073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

tip (a4a7e7e29333) build fails, when compiled with !CONFIG_SMP. 
I have only build tested the patch.

x86: Fix x86_default_fixup_cpu_id() build failure with !CONFIG_SMP

arch/x86/kernel/cpu/common.c: In function 'x86_default_fixup_cpu_id':
arch/x86/kernel/cpu/common.c:1149: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
make[3]: *** [arch/x86/kernel/cpu/common.o] Error 1

the code was introduced by commit 64be4c1c24. This patch
introduced #ifdef to guard !SMP case.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 arch/x86/kernel/cpu/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ad4da45..1154528 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1146,7 +1146,9 @@ static void dbg_restore_debug_regs(void)
  */
 void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
+#ifdef CONFIG_SMP
 	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
+#endif
 }
 
 /*

