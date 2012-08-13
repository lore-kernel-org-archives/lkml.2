Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2HMLTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:19:11 -0400
Received: from shutemov.name ([176.9.204.213]:48009 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2HMLTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:19:10 -0400
Date: Mon, 13 Aug 2012 14:19:27 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 01/12] thp: fix the count of THP_COLLAPSE_ALLOC
Message-ID: <20120813111927.GA8985@shutemov.name>
References: <5028E12C.70101@linux.vnet.ibm.com>
 <5028E14C.7060905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5028E14C.7060905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 07:13:16PM +0800, Xiao Guangrong wrote:
> THP_COLLAPSE_ALLOC is double counted if NUMA is disabled since it has
> already been calculated in khugepaged_alloc_hugepage
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

> ---
>  mm/huge_memory.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 57c4b93..80bcd42 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1880,9 +1880,9 @@ static void collapse_huge_page(struct mm_struct *mm,
>  		*hpage = ERR_PTR(-ENOMEM);
>  		return;
>  	}
> +	count_vm_event(THP_COLLAPSE_ALLOC);
>  #endif
> 
> -	count_vm_event(THP_COLLAPSE_ALLOC);
>  	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
>  #ifdef CONFIG_NUMA
>  		put_page(new_page);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
 Kirill A. Shutemov
