Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173Ab1ETB7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:59:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:49048 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934642Ab1ETB7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:59:49 -0400
Subject: Re: [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <1305753895-24845-5-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-5-git-send-email-ericvh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 10:36:09 +1000
Message-ID: <1305851769.7481.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
> For BGP, it is convenient for 'kmalloc' to come back with 32-byte
> aligned units for torus DMA
> 
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
>  arch/powerpc/include/asm/page_32.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/page_32.h b/arch/powerpc/include/asm/page_32.h
> index 68d73b2..fb0a7ae 100644
> --- a/arch/powerpc/include/asm/page_32.h
> +++ b/arch/powerpc/include/asm/page_32.h
> @@ -9,7 +9,7 @@
>  
>  #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
>  
> -#ifdef CONFIG_NOT_COHERENT_CACHE
> +#if defined(CONFIG_NOT_COHERENT_CACHE) || defined(CONFIG_BGP)
>  #define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
>  #endif

Is DMA cache coherent on BG/P ? That's odd for a 4xx base :-)

Cheers,
Ben.



