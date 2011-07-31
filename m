Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1GaIIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 04:08:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:60666 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1GaII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 04:08:27 -0400
Date: Sun, 31 Jul 2011 04:08:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731080822.GJ31842@windriver.com>
References: <20110729161931.a9c9108c233640f3c2d7b24e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729161931.a9c9108c233640f3c2d7b24e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 16:19) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 

[...]

> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 16:15:26 +1000
> Subject: [PATCH] powerpc32: include export.h for EXPORT_SYMBOL

Thanks, applied alongside the 4xx powerpc exports.

Paul.

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/kernel/iomap.c          |    1 +
>  arch/powerpc/kernel/pci_32.c         |    1 +
>  arch/powerpc/mm/mmu_context_hash32.c |    1 +
>  arch/powerpc/mm/tlb_hash32.c         |    1 +
>  4 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap.c
> index 1577434..2735872 100644
> --- a/arch/powerpc/kernel/iomap.c
> +++ b/arch/powerpc/kernel/iomap.c
> @@ -6,6 +6,7 @@
>  #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/mm.h>
> +#include <linux/export.h>
>  #include <asm/io.h>
>  #include <asm/pci-bridge.h>
>  
> diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
> index bb15451..fdd1a3d 100644
> --- a/arch/powerpc/kernel/pci_32.c
> +++ b/arch/powerpc/kernel/pci_32.c
> @@ -15,6 +15,7 @@
>  #include <linux/list.h>
>  #include <linux/of.h>
>  #include <linux/slab.h>
> +#include <linux/export.h>
>  
>  #include <asm/processor.h>
>  #include <asm/io.h>
> diff --git a/arch/powerpc/mm/mmu_context_hash32.c b/arch/powerpc/mm/mmu_context_hash32.c
> index d0ee554..78fef67 100644
> --- a/arch/powerpc/mm/mmu_context_hash32.c
> +++ b/arch/powerpc/mm/mmu_context_hash32.c
> @@ -24,6 +24,7 @@
>  
>  #include <linux/mm.h>
>  #include <linux/init.h>
> +#include <linux/export.h>
>  
>  #include <asm/mmu_context.h>
>  #include <asm/tlbflush.h>
> diff --git a/arch/powerpc/mm/tlb_hash32.c b/arch/powerpc/mm/tlb_hash32.c
> index 9a445f6..558e30c 100644
> --- a/arch/powerpc/mm/tlb_hash32.c
> +++ b/arch/powerpc/mm/tlb_hash32.c
> @@ -27,6 +27,7 @@
>  #include <linux/init.h>
>  #include <linux/highmem.h>
>  #include <linux/pagemap.h>
> +#include <linux/export.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
