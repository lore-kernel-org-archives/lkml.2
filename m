Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab0FPFqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:46:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28558 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab0FPFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:46:19 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 28/37] x86: Put 64 bit numa node memmap above 16M
Date: Tue, 15 Jun 2010 22:42:37 -0700
Message-Id: <1276666966-14259-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C18650B.0198,ss=1,fgs=0
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

