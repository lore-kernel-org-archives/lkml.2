Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1GaHa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:30:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:57167 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1GaHav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:30:51 -0400
Date: Sun, 31 Jul 2011 03:30:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731073045.GH31842@windriver.com>
References: <20110729164825.4bccf9a2924de6d4fedabd6b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729164825.4bccf9a2924de6d4fedabd6b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 16:48) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> ppx44x_defconfig) failed like this:
> 

[...]

> 
> I have added this patch for today:
> 
> From a2af733fcb26084a9a79e16d127e84900c9094e4 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 16:42:37 +1000
> Subject: [PATCH] powerpc/44x: include export.h for EXPORT_SYMBOL

Thanks, added in the queue right beside the other powerpc export
commits.

Paul.

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/include/asm/machdep.h |    1 +
>  arch/powerpc/kvm/44x.c             |    1 +
>  arch/powerpc/mm/dma-noncoherent.c  |    1 +
>  arch/powerpc/mm/tlb_nohash.c       |    1 +
>  arch/powerpc/platforms/44x/warp.c  |    1 +
>  arch/powerpc/sysdev/ppc4xx_msi.c   |    1 +
>  6 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
> index 47cacdd..7fa31ce 100644
> --- a/arch/powerpc/include/asm/machdep.h
> +++ b/arch/powerpc/include/asm/machdep.h
> @@ -12,6 +12,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/init.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/export.h>
>  
>  #include <asm/setup.h>
>  
> diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
> index da3a122..94fc29c 100644
> --- a/arch/powerpc/kvm/44x.c
> +++ b/arch/powerpc/kvm/44x.c
> @@ -20,6 +20,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
> +#include <linux/export.h>
>  
>  #include <asm/reg.h>
>  #include <asm/cputable.h>
> diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
> index b42f76c..329be36 100644
> --- a/arch/powerpc/mm/dma-noncoherent.c
> +++ b/arch/powerpc/mm/dma-noncoherent.c
> @@ -30,6 +30,7 @@
>  #include <linux/types.h>
>  #include <linux/highmem.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/export.h>
>  
>  #include <asm/tlbflush.h>
>  
> diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
> index d32ec64..ea9309e 100644
> --- a/arch/powerpc/mm/tlb_nohash.c
> +++ b/arch/powerpc/mm/tlb_nohash.c
> @@ -36,6 +36,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/memblock.h>
>  #include <linux/of_fdt.h>
> +#include <linux/export.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
> diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
> index 8f77139..4cfa499 100644
> --- a/arch/powerpc/platforms/44x/warp.c
> +++ b/arch/powerpc/platforms/44x/warp.c
> @@ -18,6 +18,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/of_i2c.h>
>  #include <linux/slab.h>
> +#include <linux/export.h>
>  
>  #include <asm/machdep.h>
>  #include <asm/prom.h>
> diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
> index 367af02..1c2d7af 100644
> --- a/arch/powerpc/sysdev/ppc4xx_msi.c
> +++ b/arch/powerpc/sysdev/ppc4xx_msi.c
> @@ -27,6 +27,7 @@
>  #include <linux/msi.h>
>  #include <linux/of_platform.h>
>  #include <linux/interrupt.h>
> +#include <linux/export.h>
>  #include <asm/prom.h>
>  #include <asm/hw_irq.h>
>  #include <asm/ppc-pci.h>
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
