Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1GZPgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:36:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52428 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1GZPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:35:50 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/23] memblock: Add __memblock_dump_all()
Date: Tue, 26 Jul 2011 17:35:15 +0200
Message-Id: <1311694534-5161-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __memblock_dump_all() which dumps memblock configuration whether
memblock_debug is enabled or not.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |    8 +++++++-
 mm/memblock.c            |    5 +----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 51abc82..b98f3fe 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -128,7 +128,13 @@ int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
 int memblock_is_reserved(phys_addr_t addr);
 int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
-void memblock_dump_all(void);
+extern void __memblock_dump_all(void);
+
+static inline void memblock_dump_all(void)
+{
+	if (memblock_debug)
+		__memblock_dump_all();
+}
 
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
diff --git a/mm/memblock.c b/mm/memblock.c
index a7e4aed..73d36ea 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -892,11 +892,8 @@ static void __init_memblock memblock_dump(struct memblock_type *type, char *name
 	}
 }
 
-void __init_memblock memblock_dump_all(void)
+void __init_memblock __memblock_dump_all(void)
 {
-	if (!memblock_debug)
-		return;
-
 	pr_info("MEMBLOCK configuration:\n");
 	pr_info(" memory size = 0x%llx\n", (unsigned long long)memblock.memory_size);
 
-- 
1.7.6

