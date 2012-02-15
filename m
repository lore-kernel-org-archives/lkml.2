Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2BOFB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:01:29 -0500
Received: from ozlabs.org ([203.10.76.45]:54677 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2BOFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Message-ID: <1329281884.32535.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 3/12] arch/hexagon: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
---
 arch/hexagon/kernel/smp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -36,7 +36,7 @@
 #define BASE_IPI_IRQ 26
 
 /*
- * cpu_possible_map needs to be filled out prior to setup_per_cpu_areas
+ * cpu_possible_mask needs to be filled out prior to setup_per_cpu_areas
  * (which is prior to any of our smp_prepare_cpu crap), in order to set
  * up the...  per_cpu areas.
  */
@@ -211,7 +211,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	stack_start =  ((void *) thread) + THREAD_SIZE;
 	__vmstart(start_secondary, stack_start);
 
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_online(cpu))
 		barrier();
 
 	return 0;
@@ -232,7 +232,7 @@ void __init smp_prepare_cpus(unsigned in
 
 	/*  Right now, let's just fake it. */
 	for (i = 0; i < max_cpus; i++)
-		cpu_set(i, cpu_present_map);
+		set_cpu_present(i, true);
 
 	/*  Also need to register the interrupts for IPI  */
 	if (max_cpus > 1)
@@ -272,5 +272,5 @@ void smp_start_cpus(void)
 	int i;
 
 	for (i = 0; i < NR_CPUS; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 }

