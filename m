Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1JWL7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:59:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45334 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1JWL7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:59:47 -0400
Date: Sun, 23 Oct 2011 12:59:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 13/16] ARM: LPAE: Add identity mapping support for
	the 3-level page table format
Message-ID: <20111023115938.GC17912@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-14-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-14-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:36PM +0100, Catalin Marinas wrote:
> The pmd_addr_end() definition has been removed and the
> generic one used instead.

NAK - it helps to read code comments.

commit c0ba10b512eb2e2a3888b6e6cc0e089f5e7a191b
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Sun Nov 21 14:42:47 2010 +0000

    ARM: improve compiler's ability to optimize page tables
    
    Allow the compiler to better optimize the page table walking code
    by avoiding over-complex pmd_addr_end() calculations.  These
    calculations prevent the compiler spotting that we'll never iterate
    over the PMD table, causing it to create double nested loops where
    a single loop will do.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index b155414..53d1d5d 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -374,6 +374,9 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 
 #define pmd_page(pmd)          pfn_to_page(__phys_to_pfn(pmd_val(pmd)))
 
+/* we don't need complex calculations here as the pmd is folded into the pgd */
+#define pmd_addr_end(addr,end) (end)
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.


