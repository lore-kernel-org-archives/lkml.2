Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0JSWux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:50:53 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8890 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab0JSWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:50:44 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>, Dezhong Diao <dediao@cisco.com>
Subject: [PATCH] of/mips: Cleanup some include directives/files.
Date: Tue, 19 Oct 2010 15:50:31 -0700
Message-Id: <1287528631-31797-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 19 Oct 2010 22:51:04.0681 (UTC) FILETIME=[1C356590:01CB6FE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __init directives should go on the definitions of things, not the
declaration, also __init is meaningless for inline functions, so
remove it from prom.h.  This allows us to get rid of a useless
#include, but most of the rest of them are useless too, so kill them
as well.

If of_i2c.c needs irq definitions, it should include linux/irq.h
directly, not assume indirect inclusion via asm/prom.h.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Dezhong Diao <dediao@cisco.com>
---
 arch/mips/include/asm/prom.h |    8 ++------
 drivers/of/of_i2c.c          |    1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/prom.h b/arch/mips/include/asm/prom.h
index 23f8237..f29b862 100644
--- a/arch/mips/include/asm/prom.h
+++ b/arch/mips/include/asm/prom.h
@@ -12,10 +12,6 @@
 #define __ASM_MIPS_PROM_H
 
 #ifdef CONFIG_OF
-#include <linux/init.h>
-
-#include <asm/setup.h>
-#include <asm/irq.h>
 #include <asm/bootinfo.h>
 
 /* which is compatible with the flattened device tree (FDT) */
@@ -27,9 +23,9 @@ extern int early_init_dt_scan_memory_arch(unsigned long node,
 extern int reserve_mem_mach(unsigned long addr, unsigned long size);
 extern void free_mem_mach(unsigned long addr, unsigned long size);
 
-extern void __init device_tree_init(void);
+extern void device_tree_init(void);
 #else /* CONFIG_OF */
-static inline void __init device_tree_init(void) { }
+static inline void device_tree_init(void) { }
 #endif /* CONFIG_OF */
 
 #endif /* _ASM_MIPS_PROM_H */
diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 0a694de..c85d3c7 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/irq.h>
 #include <linux/of.h>
 #include <linux/of_i2c.h>
 #include <linux/of_irq.h>
-- 
1.7.2.3

