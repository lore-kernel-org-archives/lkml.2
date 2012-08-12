Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2HLD6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 23:58:00 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51798 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab2HLD5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 23:57:43 -0400
Date: Sat, 11 Aug 2012 23:57:41 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v2 06/22] ARM: LPAE: use signed arithmetic for mask
 definitions
In-Reply-To: <1344648306-15619-7-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208112356470.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-7-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Cyril Chemparathy wrote:

> This patch applies to PAGE_MASK, PMD_MASK, and PGDIR_MASK, where forcing
> unsigned long math truncates the mask at the 32-bits.  This clearly does bad
> things on PAE systems.
> 
> This patch fixes this problem by defining these masks as signed quantities.
> We then rely on sign extension to do the right thing.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>

Reviewed-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/page.h           |    2 +-
>  arch/arm/include/asm/pgtable-3level.h |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
> index ecf9019..1e0fe08 100644
> --- a/arch/arm/include/asm/page.h
> +++ b/arch/arm/include/asm/page.h
> @@ -13,7 +13,7 @@
>  /* PAGE_SHIFT determines the page size */
>  #define PAGE_SHIFT		12
>  #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
> -#define PAGE_MASK		(~(PAGE_SIZE-1))
> +#define PAGE_MASK		(~((1 << PAGE_SHIFT) - 1))
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
> index b249035..ae39d11 100644
> --- a/arch/arm/include/asm/pgtable-3level.h
> +++ b/arch/arm/include/asm/pgtable-3level.h
> @@ -48,16 +48,16 @@
>  #define PMD_SHIFT		21
>  
>  #define PMD_SIZE		(1UL << PMD_SHIFT)
> -#define PMD_MASK		(~(PMD_SIZE-1))
> +#define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
>  #define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
> -#define PGDIR_MASK		(~(PGDIR_SIZE-1))
> +#define PGDIR_MASK		(~((1 << PGDIR_SHIFT) - 1))
>  
>  /*
>   * section address mask and size definitions.
>   */
>  #define SECTION_SHIFT		21
>  #define SECTION_SIZE		(1UL << SECTION_SHIFT)
> -#define SECTION_MASK		(~(SECTION_SIZE-1))
> +#define SECTION_MASK		(~((1 << SECTION_SHIFT) - 1))
>  
>  #define USER_PTRS_PER_PGD	(PAGE_OFFSET / PGDIR_SIZE)
>  
> -- 
> 1.7.9.5
> 
