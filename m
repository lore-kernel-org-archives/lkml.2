Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1DLQsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:48:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33762 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1DLQsA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Apr 2011 12:48:00 -0400
Date: Tue, 12 Apr 2011 12:47:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, yinghai@kernel.org, hpa@linux.intel.com,
        mingo@elte.hu
Subject: Re: [PATCH 1/4] xen: mask_rw_pte mark RO all pagetable pages up to
 pgt_buf_top
Message-ID: <20110412164745.GB1067@dumpdata.com>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302607192-21355-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DA48234.0116:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:19:49PM +0100, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> mask_rw_pte is currently checking if a pfn is a pagetable page if it
> falls in the range pgt_buf_start - pgt_buf_end but that is incorrect
> because pgt_buf_end is a moving target: pgt_buf_top is the real
> boundary.

OK. Stuck it on the queue for rc3.

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index c82df6c..6b833db 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1491,7 +1491,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
>  	 * it is RO.
>  	 */
>  	if (((!is_early_ioremap_ptep(ptep) &&
> -			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
> +			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
>  			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
>  		pte = pte_wrprotect(pte);
>  
> -- 
> 1.7.2.3
