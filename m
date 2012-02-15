Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2BOFBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:01:24 -0500
Received: from ozlabs.org ([203.10.76.45]:46136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2BOFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Message-ID: <1329281884.17297.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 7/12] arch/sh: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/smp.c      |    2 +-
 arch/sh/kernel/topology.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -63,7 +63,7 @@ void __init smp_prepare_cpus(unsigned in
 	mp_ops->prepare_cpus(max_cpus);
 
 #ifndef CONFIG_HOTPLUG_CPU
-	init_cpu_present(&cpu_possible_map);
+	init_cpu_present(cpu_possible_mask);
 #endif
 }
 
diff --git a/arch/sh/kernel/topology.c b/arch/sh/kernel/topology.c
--- a/arch/sh/kernel/topology.c
+++ b/arch/sh/kernel/topology.c
@@ -27,7 +27,7 @@ static cpumask_t cpu_coregroup_map(unsig
 	 * Presently all SH-X3 SMP cores are multi-cores, so just keep it
 	 * simple until we have a method for determining topology..
 	 */
-	return cpu_possible_map;
+	return *cpu_possible_mask;
 }
 
 const struct cpumask *cpu_coregroup_mask(unsigned int cpu)

