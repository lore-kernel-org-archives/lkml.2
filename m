Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0FIJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:59:58 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64670 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab0FIJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:59:57 -0400
Date: Wed, 9 Jun 2010 11:59:55 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Albert Herranz <albert_herranz@yahoo.es>,
       Grant Likely <grant.likely@secretlab.ca>, Li Yang <leoli@freescale.com>,
       Tejun Heo <tj@kernel.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/5] Removing dead CONFIG_HIGHPTE
Message-ID: <f7988844ae76cb9ac540b20db9168b5cd3109efc.1275925219.git.siccegge@cs.fau.de>
References: <cover.1275925219.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925219.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HIGHPTE doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/powerpc/mm/pgtable_32.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 9fc02dc..34347b2 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -115,11 +115,7 @@ pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *ptepage;
 
-#ifdef CONFIG_HIGHPTE
-	gfp_t flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_REPEAT | __GFP_ZERO;
-#else
 	gfp_t flags = GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO;
-#endif
 
 	ptepage = alloc_pages(flags, 0);
 	if (!ptepage)
-- 
1.6.3.3

