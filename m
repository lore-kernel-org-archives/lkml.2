Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0ESTMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:12:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40352 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0ESTMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:12:06 -0400
Message-ID: <4BF437EA.9010904@cs.helsinki.fi>
Date: Wed, 19 May 2010 22:11:38 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>, manfred@colorfullife.com,
       David Miller <davem@davemloft.net>, mpm@selenic.com, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp, cl@linux-foundation.org
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
References: <1274266725.6930.9823.camel@macbook.infradead.org> <1274266902.6930.9834.camel@macbook.infradead.org>
In-Reply-To: <1274266902.6930.9834.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

I applied patches 1-4. Thanks David!

> ---
>  include/linux/slab_def.h |   24 ++++++++++++++++++++++++
>  mm/slab.c                |   24 ------------------------
>  2 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index ca6b2b3..1812dac 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -16,6 +16,30 @@
>  #include <linux/compiler.h>
>  #include <linux/kmemtrace.h>
>  
> +#ifndef ARCH_KMALLOC_MINALIGN
> +/*
> + * Enforce a minimum alignment for the kmalloc caches.
> + * Usually, the kmalloc caches are cache_line_size() aligned, except when
> + * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
> + * Some archs want to perform DMA into kmalloc caches and need a guaranteed
> + * alignment larger than the alignment of a 64-bit integer.
> + * ARCH_KMALLOC_MINALIGN allows that.
> + * Note that increasing this value may disable some debug features.
> + */
> +#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> +#endif
> +
> +#ifndef ARCH_SLAB_MINALIGN
> +/*
> + * Enforce a minimum alignment for all caches.
> + * Intended for archs that get misalignment faults even for BYTES_PER_WORD
> + * aligned buffers. Includes ARCH_KMALLOC_MINALIGN.
> + * If possible: Do not enable this flag for CONFIG_DEBUG_SLAB, it disables
> + * some debug features.
> + */
> +#define ARCH_SLAB_MINALIGN 0
> +#endif
> +
>  /*
>   * struct kmem_cache
>   *
> diff --git a/mm/slab.c b/mm/slab.c
> index bac0f4f..7401ddc 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -144,30 +144,6 @@
>  #define	BYTES_PER_WORD		sizeof(void *)
>  #define	REDZONE_ALIGN		max(BYTES_PER_WORD, __alignof__(unsigned long long))
>  
> -#ifndef ARCH_KMALLOC_MINALIGN
> -/*
> - * Enforce a minimum alignment for the kmalloc caches.
> - * Usually, the kmalloc caches are cache_line_size() aligned, except when
> - * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
> - * Some archs want to perform DMA into kmalloc caches and need a guaranteed
> - * alignment larger than the alignment of a 64-bit integer.
> - * ARCH_KMALLOC_MINALIGN allows that.
> - * Note that increasing this value may disable some debug features.
> - */
> -#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> -#endif
> -
> -#ifndef ARCH_SLAB_MINALIGN
> -/*
> - * Enforce a minimum alignment for all caches.
> - * Intended for archs that get misalignment faults even for BYTES_PER_WORD
> - * aligned buffers. Includes ARCH_KMALLOC_MINALIGN.
> - * If possible: Do not enable this flag for CONFIG_DEBUG_SLAB, it disables
> - * some debug features.
> - */
> -#define ARCH_SLAB_MINALIGN 0
> -#endif
> -
>  #ifndef ARCH_KMALLOC_FLAGS
>  #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
>  #endif

