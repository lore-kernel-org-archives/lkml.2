Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0DIGLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:11:50 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:28380 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab0DIGJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:09:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 30/39] x86: put 64 bit numa node memmap above 16M
Date: Thu,  8 Apr 2010 23:03:59 -0700
Message-Id: <1270793048-23796-31-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBEC465.00F9,ss=1,fgs=0
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
index 18d2296..b8438ac 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -88,7 +88,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
 		return 0;
 
-	addr = 0x8000;
+	addr = __pa(MAX_DMA_ADDRESS);
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
 	nodemap_addr = lmb_find_area(addr, max_pfn<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 84e11b9..416b665 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -99,8 +99,8 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 	unsigned long phys;
 
 	length = slit->header.length;
-	phys = lmb_find_area(0, max_pfn_mapped<<PAGE_SHIFT, length,
-		 PAGE_SIZE);
+	phys = lmb_find_area(__pa(MAX_DMA_ADDRESS), max_pfn_mapped<<PAGE_SHIFT,
+				 length, PAGE_SIZE);
 
 	if (phys == -1L)
 		panic(" Can not save slit!\n");
-- 
1.6.4.2

