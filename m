Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2JRNYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:24:01 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:58067 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2JRNYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:24:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,607,1344211200"; 
   d="scan'208";a="15255386"
Date: Thu, 18 Oct 2012 14:23:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH 4/6] xen: correctly use xen_pfn_t in
 remap_domain_mfn_range.
In-Reply-To: <1350473532-15863-4-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.02.1210181422450.2689@kaball.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com> <1350473532-15863-4-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Ian Campbell wrote:
> For Xen on ARM a PFN is 64 bits so we need to use the appropriate
> type here.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

In general every mfn/pfn type should be xen_pfn_t, we might have to do a
closer audit of the code.


>  arch/x86/xen/mmu.c    |    2 +-
>  include/xen/xen-ops.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 1c5812b..d779e96 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2603,7 +2603,7 @@ static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
>  
>  int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  			       unsigned long addr,
> -			       unsigned long mfn, int nr,
> +			       xen_pfn_t mfn, int nr,
>  			       pgprot_t prot, unsigned domid,
>  			       struct page **pages)
>  
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index 6a40253..dc63e80 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -26,7 +26,7 @@ void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
>  struct vm_area_struct;
>  int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  			       unsigned long addr,
> -			       unsigned long mfn, int nr,
> +			       xen_pfn_t mfn, int nr,
>  			       pgprot_t prot, unsigned domid,
>  			       struct page **pages);
>  int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
> -- 
> 1.7.2.5
> 
