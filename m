Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2LNOem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:34:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37376 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2LNOek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:34:40 -0500
Date: Fri, 14 Dec 2012 15:34:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 02/27] x86, mm: make pgd next calculation consistent
 with pud/pmd
Message-ID: <20121214143437.GC4966@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355436141-8668-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:01:56PM -0800, Yinghai Lu wrote:
> Just like PUD_SIZE, and PMD_SIZE next calculation, aka
> round down and add size.

Why? Please explain more verbosely.

> also remove not need next checking, just pass end instead.
> later phys_pud_init uses PTRS_PER_PUD checking to exit early
> if end is too big.

Where? In the for-loop? Where does it check 'end'?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_64.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4178530..91f116a 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -530,9 +530,7 @@ kernel_physical_mapping_init(unsigned long start,
>  		pgd_t *pgd = pgd_offset_k(start);
>  		pud_t *pud;
>  
> -		next = (start + PGDIR_SIZE) & PGDIR_MASK;
> -		if (next > end)
> -			next = end;
> +		next = (start & PGDIR_MASK) + PGDIR_SIZE;
>  
>  		if (pgd_val(*pgd)) {
>  			pud = (pud_t *)pgd_page_vaddr(*pgd);
> @@ -542,7 +540,7 @@ kernel_physical_mapping_init(unsigned long start,
>  		}
>  
>  		pud = alloc_low_page();
> -		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
> +		last_map_addr = phys_pud_init(pud, __pa(start), __pa(end),
>  						 page_size_mask);
>  
>  		spin_lock(&init_mm.page_table_lock);
> -- 
> 1.7.10.4

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
