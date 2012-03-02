Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2CBAz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:55:27 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab2CBAzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:55:24 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/5] OpenRISC: Export memory_start and memory_end
Date: Fri,  2 Mar 2012 01:55:13 +0100
Message-Id: <1330649715-32438-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330649715-32438-1-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least virt_addr_valid() makes use of memory_end.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/include/asm/page.h |    4 ++--
 arch/openrisc/kernel/setup.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
index b041b34..4dfe477 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -71,8 +71,8 @@ typedef struct page *pgtable_t;
 #define __pgd(x)	((pgd_t) { (x) })
 #define __pgprot(x)	((pgprot_t) { (x) })
 
-extern unsigned long memory_start;
-extern unsigned long memory_end;
+extern phys_addr_t memory_start;
+extern phys_addr_t memory_end;
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index bf5eba2..c993c92 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -52,6 +52,7 @@
 #include "vmlinux.h"
 
 char __initdata cmd_line[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
+phys_addr_t memory_start, memory_end;
 
 static unsigned long __init setup_memory(void)
 {
@@ -59,7 +60,6 @@ static unsigned long __init setup_memory(void)
 	unsigned long ram_start_pfn;
 	unsigned long free_ram_start_pfn;
 	unsigned long ram_end_pfn;
-	phys_addr_t memory_start, memory_end;
 	struct memblock_region *region;
 
 	memory_end = memory_start = 0;
-- 
1.7.7.3

