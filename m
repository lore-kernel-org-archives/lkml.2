Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2JVOdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:33:22 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46018 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab2JVOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:33:17 -0400
Date: Mon, 22 Oct 2012 10:33:13 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] x86, mm: only keep initial mapping for ram
Message-ID: <20121022143312.GE14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:15PM -0700, Yinghai Lu wrote:
> 0 mean any e820 type, for any range is overlapped with any entry in e820,
> kernel will keep it's initial page table mapping.
> 
> What we want is only keeping initial page table for ram range.

Can you squash it in the previous patch then pls? It seems like
this is a bug-fix to a bug-fix. And since this patchset is still
out-side the Linus's tree you have the option of squashing/rebasing.

> 
> Change to E820_RAM and E820_RESERVED_KERN.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_64.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 61b3c44..4898e80 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -373,7 +373,8 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
>  		next = (addr & PAGE_MASK) + PAGE_SIZE;
>  		if (addr >= end) {
>  			if (!after_bootmem &&
> -			    !e820_any_mapped(addr & PAGE_MASK, next, 0))
> +			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
> +			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
>  				set_pte(pte, __pte(0));
>  			continue;
>  		}
> @@ -420,7 +421,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  		next = (address & PMD_MASK) + PMD_SIZE;
>  		if (address >= end) {
>  			if (!after_bootmem &&
> -			    !e820_any_mapped(address & PMD_MASK, next, 0))
> +			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
> +			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
>  				set_pmd(pmd, __pmd(0));
>  			continue;
>  		}
> @@ -494,7 +496,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  		next = (addr & PUD_MASK) + PUD_SIZE;
>  		if (addr >= end) {
>  			if (!after_bootmem &&
> -			    !e820_any_mapped(addr & PUD_MASK, next, 0))
> +			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
> +			    !e820_any_mapped(addr & PUD_MASK, next, E820_RESERVED_KERN))
>  				set_pud(pud, __pud(0));
>  			continue;
>  		}
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
