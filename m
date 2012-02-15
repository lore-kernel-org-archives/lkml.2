Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2BOFBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:01:16 -0500
Received: from ozlabs.org ([203.10.76.45]:46310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2BOFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Chris Metcalf <cmetcalf@tilera.com>
Message-ID: <1329281884.20453.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 9/12] arch/tile: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1186,7 +1186,7 @@ static void __init setup_cpu_maps(void)
 			      sizeof(cpu_lotar_map));
 	if (rc < 0) {
 		pr_err("warning: no HV_INQ_TILES_LOTAR; using AVAIL\n");
-		cpu_lotar_map = cpu_possible_map;
+		cpu_lotar_map = *cpu_possible_mask;
 	}
 
 #if CHIP_HAS_CBOX_HOME_MAP()
@@ -1196,9 +1196,9 @@ static void __init setup_cpu_maps(void)
 			      sizeof(hash_for_home_map));
 	if (rc < 0)
 		early_panic("hv_inquire_tiles(HFH_CACHE) failed: rc %d\n", rc);
-	cpumask_or(&cpu_cacheable_map, &cpu_possible_map, &hash_for_home_map);
+	cpumask_or(&cpu_cacheable_map, cpu_possible_mask, &hash_for_home_map);
 #else
-	cpu_cacheable_map = cpu_possible_map;
+	cpu_cacheable_map = *cpu_possible_mask;
 #endif
 }
 

