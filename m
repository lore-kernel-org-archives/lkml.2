Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1F1T7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:59:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:57519 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab1F1T66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:58:58 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: david@gibson.dropbear.id.au, galak@kernel.crashing.org, wli@holomorphy.com,
        benh@kernel.crashing.org
Subject: [PATCH 3/5] powerpc: mem_init should call memblock_is_reserved with phys_addr_t
Date: Tue, 28 Jun 2011 14:54:46 -0500
Message-Id: <13092910702553-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.3.rc2.29.gc4640f
In-Reply-To: <13092910103675-git-send-email-beckyb@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
 <13092909493748-git-send-email-beckyb@kernel.crashing.org>
 <13092910103675-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

This has been broken for a while but hasn't been an issue until
now because nobody was reserving regions at high addresses.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 arch/powerpc/mm/mem.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 57e545b..097b288 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -337,8 +337,9 @@ void __init mem_init(void)
 
 		highmem_mapnr = lowmem_end_addr >> PAGE_SHIFT;
 		for (pfn = highmem_mapnr; pfn < max_mapnr; ++pfn) {
+			phys_addr_t paddr = (phys_addr_t)pfn << PAGE_SHIFT;
 			struct page *page = pfn_to_page(pfn);
-			if (memblock_is_reserved(pfn << PAGE_SHIFT))
+			if (memblock_is_reserved(paddr))
 				continue;
 			ClearPageReserved(page);
 			init_page_count(page);
-- 
1.5.6.5

