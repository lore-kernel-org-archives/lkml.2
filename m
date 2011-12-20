Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1LTOOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:14:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1LTOOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:14:40 -0500
Date: Tue, 20 Dec 2011 15:14:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: hugetlb: fix pgoff computation when unmapping page
 from vma
Message-ID: <20111220141437.GJ10565@tiehlicka.suse.cz>
References: <CAJd=RBDC9hxAFbbTvSWVa=t1kuyBH8=UoTYxRDtDm6iXLGkQWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBDC9hxAFbbTvSWVa=t1kuyBH8=UoTYxRDtDm6iXLGkQWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Mel]

On Tue 20-12-11 21:45:51, Hillf Danton wrote:
> The computation for pgoff is incorrect, at least with
> 
> 	(vma->vm_pgoff >> PAGE_SHIFT)
> 
> involved. It is fixed with the available method if HPAGE_SIZE is concerned in
> page cache lookup.

Have you seen this as a real issue? I guess nobody noticed as it is
quite rare error case.
Anyways, yes, looks good. 

> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
> 
> --- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
> +++ b/mm/hugetlb.c	Tue Dec 20 21:40:44 2011
> @@ -2315,8 +2315,7 @@ static int unmap_ref_private(struct mm_s
>  	 * from page cache lookup which is in HPAGE_SIZE units.
>  	 */
>  	address = address & huge_page_mask(h);
> -	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
> -		+ (vma->vm_pgoff >> PAGE_SHIFT);
> +	pgoff = linear_hugepage_index(vma, address);

You have hstate so you can use vma_hugecache_offset directly

>  	mapping = (struct address_space *)page_private(page);
> 
>  	/*
> 

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
