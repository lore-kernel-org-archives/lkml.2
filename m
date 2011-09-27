Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1I0BZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 21:25:29 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:50364 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1I0BZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 21:25:28 -0400
Date: Tue, 27 Sep 2011 11:25:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk@arm.linux.org.uk>, Jon Medhurst <tixy@yxit.co.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

[I have a feeling that I may have reported this previously]

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mm/dma-mapping.c between commit e73fc88e19d7 ("ARM: 7059/1:
LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*") from the arm tree
and commit 99d1717dd7fe ("ARM: Add init_consistent_dma_size()") from the
arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/dma-mapping.c
index 235eb77,50be842..0000000
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@@ -117,14 -119,10 +119,9 @@@ static void __dma_free_buffer(struct pa
  }
  
  #ifdef CONFIG_MMU
- /* Sanity check size */
- #if (CONSISTENT_DMA_SIZE % SZ_2M)
- #error "CONSISTENT_DMA_SIZE must be multiple of 2MiB"
- #endif
  
- #define CONSISTENT_OFFSET(x)	(((unsigned long)(x) - CONSISTENT_BASE) >> PAGE_SHIFT)
- #define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - CONSISTENT_BASE) >> PMD_SHIFT)
- #define NUM_CONSISTENT_PTES (CONSISTENT_DMA_SIZE >> PMD_SHIFT)
 -
+ #define CONSISTENT_OFFSET(x)	(((unsigned long)(x) - consistent_base) >> PAGE_SHIFT)
 -#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - consistent_base) >> PGDIR_SHIFT)
++#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - consistent_base) >> PMD_SHIFT)
  
  /*
   * These are the page tables (2MB each) covering uncached, DMA consistent allocations
