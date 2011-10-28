Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab1J1OXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:23:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65189 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1J1OXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:23:32 -0400
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC/PATCH 3/7] x86, mm: Use max_pfn instead of highend_pfn
Date: Fri, 28 Oct 2011 17:23:17 +0300
Message-Id: <1319811801-1725-3-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319811801-1725-1-git-send-email-penberg@kernel.org>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'highend_pfn' variable is always set to 'max_pfn' so just use the latter
directly.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init_32.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 434c97d..6101894 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -54,7 +54,7 @@
 #include <asm/page_types.h>
 #include <asm/init.h>
 
-unsigned long highstart_pfn, highend_pfn;
+unsigned long highstart_pfn;
 
 static noinline int do_test_wp_bit(void);
 
@@ -647,14 +647,14 @@ void __init find_low_pfn_range(void)
 void __init initmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
-	highstart_pfn = highend_pfn = max_pfn;
+	highstart_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memblock_x86_register_active_regions(0, 0, highend_pfn);
+	memblock_x86_register_active_regions(0, 0, max_pfn);
 	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
-		pages_to_mb(highend_pfn - highstart_pfn));
-	num_physpages = highend_pfn;
+		pages_to_mb(max_pfn - highstart_pfn));
+	num_physpages = max_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
 	memblock_x86_register_active_regions(0, 0, max_low_pfn);
@@ -683,7 +683,7 @@ static void __init zone_sizes_init(void)
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
 #endif
 
 	free_area_init_nodes(max_zone_pfns);
-- 
1.7.6.4

