Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935133Ab1KJPXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:23:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934386Ab1KJPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:23:16 -0500
Date: Thu, 10 Nov 2011 16:23:12 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5]thp: remove unnecessary tlb flush for mprotect
Message-ID: <20111110152312.GY5075@redhat.com>
References: <1319511565.22361.138.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319511565.22361.138.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:59:25AM +0800, Shaohua Li wrote:
> change_protection() will do TLB flush later, don't need duplicate tlb flush.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  mm/huge_memory.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux/mm/huge_memory.c
> ===================================================================
> --- linux.orig/mm/huge_memory.c	2011-10-24 19:24:31.000000000 +0800
> +++ linux/mm/huge_memory.c	2011-10-24 19:25:10.000000000 +0800
> @@ -1079,7 +1079,6 @@ int change_huge_pmd(struct vm_area_struc
>  			entry = pmd_modify(entry, newprot);
>  			set_pmd_at(mm, addr, pmd, entry);
>  			spin_unlock(&vma->vm_mm->page_table_lock);
> -			flush_tlb_range(vma, addr, addr + HPAGE_PMD_SIZE);
>  			ret = 1;
>  		}
>  	} else

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
