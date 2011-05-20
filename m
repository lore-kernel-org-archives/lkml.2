Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab1ETW0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:26:24 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2122 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab1ETWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:25:59 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v4 4/6] MIPS: Prune some target specific code out of prom.c
Date: Fri, 20 May 2011 15:25:41 -0700
Message-Id: <1305930343-31259-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 20 May 2011 22:25:58.0688 (UTC) FILETIME=[E48DDA00:01CC173C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is not common enough to be in a shared file.  It is also not
used by any existing boards, so just remove it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/kernel/prom.c |   49 -----------------------------------------------
 1 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index a19811e9..a07b6f1 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -59,52 +59,3 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 	initrd_below_start_ok = 1;
 }
 #endif
-
-/*
- * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
- *
- * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
- * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
- * supported.
- */
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
-void __init early_init_devtree(void *params)
-{
-	/* Setup flat device-tree pointer */
-	initial_boot_params = params;
-
-	/* Retrieve various informations from the /chosen node of the
-	 * device-tree, including the platform type, initrd location and
-	 * size, and more ...
-	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
-
-	/* Scan memory nodes */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	of_scan_flat_dt(early_init_dt_scan_memory_arch, NULL);
-}
-
-void __init device_tree_init(void)
-{
-	unsigned long base, size;
-
-	if (!initial_boot_params)
-		return;
-
-	base = virt_to_phys((void *)initial_boot_params);
-	size = be32_to_cpu(initial_boot_params->totalsize);
-
-	/* Before we do anything, lets reserve the dt blob */
-	reserve_mem_mach(base, size);
-
-	unflatten_device_tree();
-
-	/* free the space reserved for the dt blob */
-	free_mem_mach(base, size);
-}
-- 
1.7.2.3

