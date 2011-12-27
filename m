Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1L0M5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 07:57:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab1L0M5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 07:57:03 -0500
Date: Tue, 27 Dec 2011 13:57:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
Message-ID: <20111227125701.GG5344@tiehlicka.suse.cz>
References: <CAJd=RBCS3-PoFa3FUVwhiznPTQH5xq7fTYa3m01a0-buACQbCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCS3-PoFa3FUVwhiznPTQH5xq7fTYa3m01a0-buACQbCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-12-11 21:38:38, Hillf Danton wrote:
> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
> 
> If we have to hand back the newly allocated huge page to page allocator,
> for any reason, the changed counter should be recovered.
> 
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Broken since 2.6.27 (caff3a2c: hugetlb: call arch_prepare_hugepage() for
surplus pages) so a stable material

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks
> ---
> 
> --- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
> +++ b/mm/hugetlb.c	Fri Dec 23 21:18:06 2011
> @@ -800,7 +800,7 @@ static struct page *alloc_buddy_huge_pag
> 
>  	if (page && arch_prepare_hugepage(page)) {
>  		__free_pages(page, huge_page_order(h));
> -		return NULL;
> +		page = NULL;
>  	}
> 
>  	spin_lock(&hugetlb_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
