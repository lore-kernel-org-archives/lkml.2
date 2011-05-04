Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1EDSSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:18:14 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52818 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1EDSSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:18:12 -0400
Date: Wed, 4 May 2011 20:18:05 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 5/8] arch/x86/xen/smp: Cleanup code/data sections definitions
Message-ID: <20110504181805.GF29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/smp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3061244..194a3ed 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -57,7 +57,7 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static __cpuinit void cpu_bringup(void)
+static void __cpuinit cpu_bringup(void)
 {
 	int cpu = smp_processor_id();
 
@@ -85,7 +85,7 @@ static __cpuinit void cpu_bringup(void)
 	wmb();			/* make sure everything is out */
 }
 
-static __cpuinit void cpu_bringup_and_idle(void)
+static void __cpuinit cpu_bringup_and_idle(void)
 {
 	cpu_bringup();
 	cpu_idle();
@@ -242,7 +242,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-static __cpuinit int
+static int __cpuinit
 cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 {
 	struct vcpu_guest_context *ctxt;
@@ -486,7 +486,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static const struct smp_ops xen_smp_ops __initdata = {
+static const struct smp_ops xen_smp_ops __initconst = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
 	.smp_cpus_done = xen_smp_cpus_done,
-- 
1.5.6.5
