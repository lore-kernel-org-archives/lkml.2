Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0HMGqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 02:46:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:47369 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0HMGqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 02:46:08 -0400
Date: Fri, 13 Aug 2010 15:45:34 +0900
To: heiko.carstens@de.ibm.com
Cc: sachinp@in.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
References: <4C63A551.3040701@in.ibm.com>
	<20100812075532.GA7814@osiris.boeblingen.de.ibm.com>
	<20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100813154412F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 13 Aug 2010 15:45:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 10:07:01 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Crap. By far not all converted architectures include dma-mapping-common.h
> from their private dma-mapping header file. So the patch would probably
> introduce a couple of new compile errors.
> Looks like we need an explicit ifdef.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  include/linux/dma-mapping.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index e0670a5..ce29b81 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -142,6 +142,7 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
>  		return -EIO;
>  }
>  
> +#ifdef CONFIG_HAS_DMA
>  static inline int dma_get_cache_alignment(void)
>  {
>  #ifdef ARCH_DMA_MINALIGN
> @@ -149,6 +150,7 @@ static inline int dma_get_cache_alignment(void)
>  #endif
>  	return 1;
>  }
> +#endif

Very sorry about this.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Looks like we had better to clean up dma-mapping headers on both
HAS_DMA and !HAS_DMA though.
