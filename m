Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1CGRwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:52:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:56353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1CGRtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:09 -0500
Message-Id: <20110307172207.242624219@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Mar 2011 18:14:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [RFC][PATCH 11/15] mm, avr32: Convert avr32 to generic tlb
References: <20110307171350.989666626@chello.nl>
Content-Disposition: inline; filename=avr32-mmu_range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/avr32/Kconfig           |    1 +
 arch/avr32/include/asm/tlb.h |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/arch/avr32/Kconfig
===================================================================
--- linux-2.6.orig/arch/avr32/Kconfig
+++ linux-2.6/arch/avr32/Kconfig
@@ -7,6 +7,7 @@ config AVR32
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_MMU_GATHER_RANGE
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: linux-2.6/arch/avr32/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/tlb.h
+++ linux-2.6/arch/avr32/include/asm/tlb.h
@@ -8,12 +8,6 @@
 #ifndef __ASM_AVR32_TLB_H
 #define __ASM_AVR32_TLB_H
 
-#define tlb_start_vma(tlb, vma) \
-	flush_cache_range(vma, vma->vm_start, vma->vm_end)
-
-#define tlb_end_vma(tlb, vma) \
-	flush_tlb_range(vma, vma->vm_start, vma->vm_end)
-
 #define __tlb_remove_tlb_entry(tlb, pte, address) do { } while(0)
 
 #include <asm-generic/tlb.h>


