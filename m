Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab0ELX2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:28:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755857Ab0ELX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:28:43 -0400
Date: Wed, 12 May 2010 16:28:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, Pete Eberlein <pete@sensoray.com>,
       Ross Cohen <rcohen@snurgle.org>, Greg KH <greg@kroah.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH -mm] remove deprecated dma_sync_single and dma_sync_sg
 API
Message-Id: <20100512162803.ccb05cb8.akpm@linux-foundation.org>
In-Reply-To: <20100511101308R.fujita.tomonori@lab.ntt.co.jp>
References: <20100511101308R.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 10:13:23 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Since 2.6.5, it had been commented, 'for backwards compatibility,
> removed in 2.7.x'. Since 2.6.31, it have been marked as __deprecated.
> 
> I think that we can remove the API safely now.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/linux/dma-mapping.h |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 2ea1494..89b7e1a 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -95,21 +95,6 @@ static inline int is_device_dma_capable(struct device *dev)
>  #include <asm-generic/dma-mapping-broken.h>
>  #endif
>  
> -/* for backwards compatibility, removed soon */
> -static inline void __deprecated dma_sync_single(struct device *dev,
> -						dma_addr_t addr, size_t size,
> -						enum dma_data_direction dir)
> -{
> -	dma_sync_single_for_cpu(dev, addr, size, dir);
> -}
> -
> -static inline void __deprecated dma_sync_sg(struct device *dev,
> -					    struct scatterlist *sg, int nelems,
> -					    enum dma_data_direction dir)
> -{
> -	dma_sync_sg_for_cpu(dev, sg, nelems, dir);
> -}
> -
>  static inline u64 dma_get_mask(struct device *dev)
>  {
>  	if (dev && dev->dma_mask && *dev->dma_mask)

drivers/staging/go7007/saa7134-go7007.c uses dma_sync_single().

arch/ia64/kernel/machvec.c has functions machvec_dma_sync_single() and
machvec_dma_sync_sg() which might be dead code.

