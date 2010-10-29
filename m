Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab0J2RWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:22:39 -0400
Received: from claw.goop.org ([74.207.240.146]:42691 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701Ab0J2RWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:22:38 -0400
Message-ID: <4CCB02DC.1010307@goop.org>
Date: Fri, 29 Oct 2010 10:22:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: correct size of level2_kernel_pgt
References: <1288367779-24001-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1288367779-24001-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/29/2010 08:56 AM, Ian Campbell wrote:
> sizeof(pmd_t *) is 4 bytes on PAE leading to an allocation of only
> 2048 bytes. The correct size is sizeof(pmd_t) giving us a full page
> allocation.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>
> Applies to mainline since 2.6.36 and to xen.git 2.6.32 based trees

This is just for 2.6.37?

    J

>  arch/x86/xen/mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index c237b81..21ed8d7 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2126,7 +2126,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
>  {
>  	pmd_t *kernel_pmd;
>  
> -	level2_kernel_pgt = extend_brk(sizeof(pmd_t *) * PTRS_PER_PMD, PAGE_SIZE);
> +	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
>  
>  	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
>  				  xen_start_info->nr_pt_frames * PAGE_SIZE +

