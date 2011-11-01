Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1KAN7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:59:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44940 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1KAN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:58:59 -0400
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Arun Sharma <asharma@fb.com>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 6/7] x86, mm: Prepare zone_sizes_init() for unification
Date: Tue,  1 Nov 2011 15:58:21 +0200
Message-Id: <1320155902-10424-6-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320155902-10424-1-git-send-email-penberg@kernel.org>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make 32-bit and 64-bit zone_sizes_init() identical in preparation for
unification.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init_32.c |    4 ++++
 arch/x86/mm/init_64.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5ac0118..27455b9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -677,10 +677,14 @@ void __init initmem_init(void)
 static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 #endif
+#ifdef CONFIG_ZONE_DMA32
+        max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f6b1f08..06c4360 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -624,6 +624,9 @@ static void __init zone_sizes_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#endif
 
 	free_area_init_nodes(max_zone_pfns);
 }
-- 
1.7.6.4

