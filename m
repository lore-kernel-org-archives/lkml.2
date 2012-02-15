Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029Ab2C3VGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:21 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934999Ab2C3VGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:14 -0400
Message-Id: <201203302105.q2UL58rb006308@farm-0012.internal.tilera.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH] arch/tile: remove references to cpu_*_map.
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:09.0069 (UTC) FILETIME=[CA13F7D0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 825bc64..1d43be6 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1244,7 +1244,7 @@ static void __init setup_cpu_maps(void)
 			      sizeof(cpu_lotar_map));
 	if (rc < 0) {
 		pr_err("warning: no HV_INQ_TILES_LOTAR; using AVAIL\n");
-		cpu_lotar_map = cpu_possible_map;
+		cpu_lotar_map = *cpu_possible_mask;
 	}
 
 #if CHIP_HAS_CBOX_HOME_MAP()
@@ -1254,9 +1254,9 @@ static void __init setup_cpu_maps(void)
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
 
-- 
1.6.5.2

