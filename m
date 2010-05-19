Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0ESPzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:55:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:37249 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab0ESPzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:55:32 -0400
Date: Wed, 19 May 2010 23:50:08 +0900
To: dwmw2@infradead.org
Cc: herbert@gondor.hengli.com.au, vapier@gentoo.org, npiggin@suse.de,
       os@emlix.com, davem@davemloft.net, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [PATCH 5/4] Provide __dma_aligned macro
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1274276948.6930.10117.camel@macbook.infradead.org>
References: <20100519010524.GB18813@gondor.apana.org.au>
	<1274266725.6930.9823.camel@macbook.infradead.org>
	<1274276948.6930.10117.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100519235158A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 23:50:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 14:49:08 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Commit 3843384a055496dfed3c93ae883d964d8290fdab ("Input: ad7877 - keep
> dma rx buffers in seperate cache lines")[sic] introduced the use of
> ____cacheline_aligned to ensure that buffers used for DMA as part of a
> structure were suitably separated from the rest of the structure.
> 
> However, aligning to the cache line size isn't necessary on
> cache-coherent architectures. To avoid wasting space, the correct value
> to use for the alignment is ARCH_KMALLOC_MINALIGN.
> 
> This patch provides a __dma_aligned macro which does the right thing.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index ca32ed7..4487cf3 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -5,6 +5,9 @@
>  #include <linux/err.h>
>  #include <linux/dma-attrs.h>
>  #include <linux/scatterlist.h>
> +#include <linux/slab.h>
> +
> +#define __dma_aligned __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN)))

As wrote in other mail, such was proposed several times:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12633.html
http://lwn.net/Articles/2269/

And rejected.

http://lwn.net/Articles/2270/
