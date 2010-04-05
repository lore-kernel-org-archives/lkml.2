Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0DEXq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:46:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:57170 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab0DEXqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:46:51 -0400
Date: Tue, 6 Apr 2010 08:46:38 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH -mm 2/5] asm-generic: add NEED_SG_DMA_LENGTH to define
 sg_dma_len()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100405163541.aa10c605.akpm@linux-foundation.org>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1270391153-17519-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100405163541.aa10c605.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100406084603B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:46:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Apr 2010 16:35:41 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun,  4 Apr 2010 23:25:50 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > There are only two ways to define sg_dma_len(); use sg->dma_length or
> > sg->length. This patch introduces NEED_SG_DMA_LENGTH that enables
> > architectures to choose sg->dma_length or sg->length.
> 
> i386 allnoconfig:
> 
> arch/x86/kernel/pci-nommu.c: In function 'nommu_map_sg':
> arch/x86/kernel/pci-nommu.c:71: error: 'struct scatterlist' has no member named 'dma_length'
> 
> So I enabled NEED_SG_DMA_LENGTH on x86_32 as well.  It compiles...

Sorry about that. The fix is fine by me. We can remove dma_length in
pci-nommu.c though (there is no point of setting dma_length here).

Thanks,
