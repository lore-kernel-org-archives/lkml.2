Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0DEXg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:36:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845Ab0DEXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:36:22 -0400
Date: Mon, 5 Apr 2010 16:35:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH -mm 2/5] asm-generic: add NEED_SG_DMA_LENGTH to define
 sg_dma_len()
Message-Id: <20100405163541.aa10c605.akpm@linux-foundation.org>
In-Reply-To: <1270391153-17519-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1270391153-17519-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  4 Apr 2010 23:25:50 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> There are only two ways to define sg_dma_len(); use sg->dma_length or
> sg->length. This patch introduces NEED_SG_DMA_LENGTH that enables
> architectures to choose sg->dma_length or sg->length.

i386 allnoconfig:

arch/x86/kernel/pci-nommu.c: In function 'nommu_map_sg':
arch/x86/kernel/pci-nommu.c:71: error: 'struct scatterlist' has no member named 'dma_length'

So I enabled NEED_SG_DMA_LENGTH on x86_32 as well.  It compiles...

--- a/arch/x86/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len-fix
+++ a/arch/x86/Kconfig
@@ -103,7 +103,7 @@ config NEED_DMA_MAP_STATE
        def_bool (X86_64 || DMAR || DMA_API_DEBUG)
 
 config NEED_SG_DMA_LENGTH
-	def_bool X86_64
+	def_bool y
 
 config GENERIC_ISA_DMA
 	def_bool y
diff -puN include/asm-generic/scatterlist.h~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len-fix include/asm-generic/scatterlist.h
_

