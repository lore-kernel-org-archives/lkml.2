Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2JIQZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:25:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59523 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2JIQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:24:57 -0400
Date: Tue, 9 Oct 2012 12:13:09 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 07/10] x86, xen, mm: Do not need to check if page table
 is ioremap
Message-ID: <20121009161307.GI7639@phenom.dumpdata.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
 <1349757558-10856-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349757558-10856-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 09:39:15PM -0700, Yinghai Lu wrote:
> All page table buf are pre-mapped, and could use _va to access them.

"__va", not "_va". And can you also include the name of the patch
that makes them pre-mapped?

> 
> Remove the not needed checking.

<sigh>
"Remove the ioremap check."

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  arch/x86/xen/mmu.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 7a769b7..9c0956c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1412,13 +1412,9 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
>  
>  	/*
>  	 * If the new pfn is within the range of the newly allocated
> -	 * kernel pagetable, and it isn't being mapped into an
> -	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> -	 * it is RO.
> +	 * kernel pagetable, make sure it is RO.
>  	 */
> -	if (((!is_early_ioremap_ptep(ptep) &&
> -			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
> -			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
> +	if (pfn >= pgt_buf_start && pfn < pgt_buf_top)
>  		pte = pte_wrprotect(pte);
>  
>  	return pte;
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
