Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0ICWKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:10:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab0ICWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:10:21 -0400
Date: Fri, 3 Sep 2010 15:09:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 0/8] unify dma_addr_t typedef
 (CONFIG_ARCH_DMA_ADDR_T_64BIT)
Message-Id: <20100903150948.4b612498.akpm@linux-foundation.org>
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 09:51:31 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> There are about twenty architectures have the own dma_addr_t typedef
> because include/asm-generic/types.h can't be perfect (some of them can
> use it though):
> 
> #ifndef dma_addr_t
> #ifdef CONFIG_PHYS_ADDR_T_64BIT
> typedef u64 dma_addr_t;
> #else
> typedef u32 dma_addr_t;
> #endif /* CONFIG_PHYS_ADDR_T_64BIT */
> #endif /* dma_addr_t */
> 
> Another problem is that there is a way to determine if dma_addr_t is
> 64-bit. We see hopeless tricks like the following:
> 
> #if (defined(__i386__) && defined(CONFIG_HIGHMEM64G)) || defined(__x86_64__) || defined (__ia64__) || defined(__alpha__) || defined(__mips64__) || (defined(__mips__) && defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR))
> 
> This clean up the mess with introducing CONFIG_ARCH_DMA_ADDR_T_64BIT
> define (like CONFIG_ARCH_PHYS_ADDR_T_64BIT).
> 
> If architecture needs 64bit dma_addr_t, it must enable
> CONFIG_ARCH_DMA_ADDR_T_64BIT.
> 
> The summary are:
> 
> - always 64bit
> -- alpha
> -- ia64
> -- tile
> 
> - conditionally 64bit
> -- x86
> -- mips
> -- powerpc
> -- s390
> 
> - always 32bit
> -- arm
> -- avr32
> -- cris
> -- frv
> -- h8300
> -- m32r
> -- m68k
> -- mn10300
> -- parisc
> -- xtensa
> -- sparc
> -- blackfin
> -- microblaze
> -- score
> -- sh

Am I correct in believing that we can merge the first seven patches
into arch trees at any time and, once they are all merged, patch 8/8
can then go into mainline?

