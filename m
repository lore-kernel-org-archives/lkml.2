Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0F2OjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:39:18 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:51892 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab0F2OjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:39:17 -0400
Message-ID: <4C2A0592.50709@tilera.com>
Date: Tue, 29 Jun 2010 10:39:14 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] tile: set ARCH_KMALLOC_MINALIGN
References: <20100629164117Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100629164117Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sounds OK.   The TILE-Gx chip does coherent DMA, so won't need
this, I assume?  If you want to guard this suitably, you can add
"#ifndef __tilegx__" around it and add a comment that TILE-Gx has
coherent IO.  Thanks.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

On 6/29/2010 3:43 AM, FUJITA Tomonori wrote:
> The minimum alignment and width of DMA is L2_CACHE_BYTES (because your
> dma_get_cache_alignment() returns L2_CACHE_BYTES), right?
>
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH -next] tile: set ARCH_KMALLOC_MINALIGN
>
> Architectures that handle DMA-non-coherent memory need to set
> ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
> the buffer doesn't share a cache with the others.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/tile/include/asm/cache.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
> index ee59714..e08d9e8 100644
> --- a/arch/tile/include/asm/cache.h
> +++ b/arch/tile/include/asm/cache.h
> @@ -31,6 +31,8 @@
>  #define L2_CACHE_BYTES		(1 << L2_CACHE_SHIFT)
>  #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
>  
> +#define ARCH_KMALLOC_MINALIGN	L2_CACHE_BYTES
> +
>  /* use the cache line size for the L2, which is where it counts */
>  #define SMP_CACHE_BYTES_SHIFT	L2_CACHE_SHIFT
>  #define SMP_CACHE_BYTES		L2_CACHE_BYTES
>   

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

