Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2HDGyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:54:19 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42365 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2HDGyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:54:17 -0400
Date: Sat, 4 Aug 2012 02:54:14 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 07/22] ARM: LPAE: use phys_addr_t in free_memmap()
In-Reply-To: <1343775898-28345-8-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040253140.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-8-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> From: Vitaly Andrianov <vitalya@ti.com>
> 
> The free_memmap() was mistakenly using unsigned long type to represent
> physical addresses.  This breaks on PAE systems where memory could be placed
> above the 32-bit addressible limit.
> 
> This patch fixes this function to properly use phys_addr_t instead.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/mm/init.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index f54d592..8252c31 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -457,7 +457,7 @@ static inline void
>  free_memmap(unsigned long start_pfn, unsigned long end_pfn)
>  {
>  	struct page *start_pg, *end_pg;
> -	unsigned long pg, pgend;
> +	phys_addr_t pg, pgend;
>  
>  	/*
>  	 * Convert start_pfn/end_pfn to a struct page pointer.
> @@ -469,8 +469,8 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
>  	 * Convert to physical addresses, and
>  	 * round start upwards and end downwards.
>  	 */
> -	pg = (unsigned long)PAGE_ALIGN(__pa(start_pg));
> -	pgend = (unsigned long)__pa(end_pg) & PAGE_MASK;
> +	pg = PAGE_ALIGN(__pa(start_pg));
> +	pgend = __pa(end_pg) & PAGE_MASK;
>  
>  	/*
>  	 * If there are free pages between these,
> -- 
> 1.7.9.5
> 
