Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2HDGvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:51:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38647 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2HDGvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:51:50 -0400
Date: Sat, 4 Aug 2012 02:51:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 06/22] ARM: LPAE: use phys_addr_t in alloc_init_pud()
In-Reply-To: <1343775898-28345-7-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040251020.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-7-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> From: Vitaly Andrianov <vitalya@ti.com>
> 
> This patch fixes the alloc_init_pud() function to use phys_addr_t instead of
> unsigned long when passing in the phys argument.
> 
> This is an extension to commit 97092e0c56830457af0639f6bd904537a150ea4a, which
> applied similar changes elsewhere in the ARM memory management code.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/mm/mmu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index cf4528d..226985c 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -628,7 +628,8 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
>  }
>  
>  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> -	unsigned long end, unsigned long phys, const struct mem_type *type)
> +				  unsigned long end, phys_addr_t phys,
> +				  const struct mem_type *type)
>  {
>  	pud_t *pud = pud_offset(pgd, addr);
>  	unsigned long next;
> -- 
> 1.7.9.5
> 
