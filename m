Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0ICXkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:40:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481Ab0ICXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:40:41 -0400
Date: Fri, 3 Sep 2010 16:40:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] fsldma: fix missing header include
Message-Id: <20100903164033.6ae37727.akpm@linux-foundation.org>
In-Reply-To: <20100902194752.GA24861@ovro.caltech.edu>
References: <20100902194752.GA24861@ovro.caltech.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 12:47:52 -0700
"Ira W. Snyder" <iws@ovro.caltech.edu> wrote:

> The slab.h header is required to use the kmalloc() family of functions.
> Due to recent kernel changes, this header must be directly included by
> code that calls into the memory allocator.
> 
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
> 
> Without this patch, any code which includes this header fails to build.
> 
>  arch/powerpc/include/asm/fsldma.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/fsldma.h b/arch/powerpc/include/asm/fsldma.h
> index a67aeed..debc5ed 100644
> --- a/arch/powerpc/include/asm/fsldma.h
> +++ b/arch/powerpc/include/asm/fsldma.h
> @@ -11,6 +11,7 @@
>  #ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
>  #define __ARCH_POWERPC_ASM_FSLDMA_H__
>  
> +#include <linux/slab.h>
>  #include <linux/dmaengine.h>
>  

It also needs list.h, but appears to get it via sheer luck.

The functions in that header simply shouldn't have been inlined.

It's peculiar that fsl_dma_slave_append() hardwires GFP_ATOMIC, whereas
fsl_dma_slave_alloc() takes a gfp_t.

