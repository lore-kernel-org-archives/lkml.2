Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0HYOQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:16:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33493 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0HYOQK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 25 Aug 2010 10:16:10 -0400
Date: Wed, 25 Aug 2010 10:15:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: vapier@gentoo.org, linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
        dgdegra@tycho.nsa.gov, hugh@veritas.com, airlied@linux.ie,
        davej@redhat.com
Subject: Re: [PATCH] NOMMU: Stub out vm_get_page_prot() if there's no MMU
Message-ID: <20100825141500.GA4394@phenom.dumpdata.com>
References: <20100824222238.6372.8897.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824222238.6372.8897.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:22:38PM +0100, David Howells wrote:
> Stub out vm_get_page_prot() if there's no MMU.
> 
> This was added by commit:
> 
> 	commit 804af2cf6e7af31d2e664b54e657dddd9b531dbd
> 	Author: Hugh Dickins <hugh@veritas.com>
> 	Date:   Wed Jul 26 21:39:49 2006 +0100
> 	Subject: [AGPGART] remove private page protection map
> 
> and is used in commit:
> 
> 	commit c07fbfd17e614a76b194f371c5331e21e6cffb54
> 	Author: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> 	Date:   Tue Aug 10 18:02:45 2010 -0700
> 	Subject: fbmem: VM_IO set, but not propagated
> 
> in the fbmem video driver, but the function doesn't exist on NOMMU, resulting
> in an undefined symbol at link time.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks for coming up with the patch!

> ---
> 
>  include/linux/mm.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 709f672..6b258c5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1357,7 +1357,15 @@ static inline unsigned long vma_pages(struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +#ifdef CONFIG_MMU
>  pgprot_t vm_get_page_prot(unsigned long vm_flags);
> +#else
> +static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
> +{
> +	return __pgprot(0);
> +}
> +#endif
> +
>  struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
>  int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
>  			unsigned long pfn, unsigned long size, pgprot_t);
