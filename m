Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1KKCYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:24:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51887 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1KKCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:22:17 -0500
From: ddaney.cavm@gmail.com
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 2/8] MIPS: Prune some target specific code out of prom.c
Date: Thu, 10 Nov 2011 18:21:58 -0800
Message-Id: <1320978124-13042-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1320978124-13042-1-git-send-email-ddaney.cavm@gmail.com>
References: <1320978124-13042-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This code is not common enough to be in a shared file.  It is also not
used by any existing boards, so just remove it.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/prom.c |   50 -----------------------------------------------
 1 files changed, 0 insertions(+), 50 deletions(-)

diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 6b8b420..04bf462 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -59,53 +59,3 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
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
-	of_scan_flat_dt(early_init_dt_scan_chosen, arcs_cmdline);
-
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

