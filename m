Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab0F3DtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 23:49:21 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:61472 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0F3DtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 23:49:20 -0400
Message-ID: <4C2ABEBC.1010609@tilera.com>
Date: Tue, 29 Jun 2010 23:49:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] tile: set ARCH_KMALLOC_MINALIGN
References: <20100629164117Z.fujita.tomonori@lab.ntt.co.jp>	<4C2A0592.50709@tilera.com> <20100630110749V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100630110749V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2010 10:10 PM, FUJITA Tomonori wrote:
> Ok, here's the second version.
>
> Can I assume that you'll merge the patch into your git tree on
> kernel.org?
>   

Sure, I'll take this patch into my arch/tile tree on kernel.org.  I
already took (a superset of) the one removing L1_CACHE_ALIGN as well. 
Thanks.

> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] tile: set ARCH_KMALLOC_MINALIGN
>
> Architectures that handle DMA-non-coherent memory need to set
> ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
> the buffer doesn't share a cache with the others.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/tile/include/asm/cache.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
> index ee59714..869a14f 100644
> --- a/arch/tile/include/asm/cache.h
> +++ b/arch/tile/include/asm/cache.h
> @@ -31,6 +31,14 @@
>  #define L2_CACHE_BYTES		(1 << L2_CACHE_SHIFT)
>  #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
>  
> +/*
> + * TILE-Gx is fully coherents so we don't need to define
> + * ARCH_KMALLOC_MINALIGN.
> + */
> +#ifndef __tilegx__
> +#define ARCH_KMALLOC_MINALIGN	L2_CACHE_BYTES
> +#endif
> +
>  /* use the cache line size for the L2, which is where it counts */
>  #define SMP_CACHE_BYTES_SHIFT	L2_CACHE_SHIFT
>  #define SMP_CACHE_BYTES		L2_CACHE_BYTES
>   

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

