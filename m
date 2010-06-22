Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab0FVR3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:29:52 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:46132 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759142Ab0FVR3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:29:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 24/25] x86: Put 64 bit numa node memmap above 16M
Date: Tue, 22 Jun 2010 10:26:53 -0700
Message-Id: <1277227614-11581-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C20F2C7.01AF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use 0x8000 hard code value anymore.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa_64.c |    2 +-
 arch/x86/mm/srat_64.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 92c01a5..93a1e07 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -85,7 +85,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
 		return 0;
 
-	addr = 0x8000;
+	addr = __pa(MAX_DMA_ADDRESS);
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
 	nodemap_addr = lmb_find_in_range(addr, max_pfn<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 8f82c80..1f9b7b7 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -99,8 +99,8 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 	unsigned long phys;
 
 	length = slit->header.length;
-	phys = lmb_find_in_range(0, max_pfn_mapped<<PAGE_SHIFT, length,
-		 PAGE_SIZE);
+	phys = lmb_find_in_range(__pa(MAX_DMA_ADDRESS), max_pfn_mapped<<PAGE_SHIFT,
+				 length, PAGE_SIZE);
 
 	if (phys == (unsigned long)LMB_ERROR)
 		panic(" Can not save slit!\n");
-- 
1.6.4.2

