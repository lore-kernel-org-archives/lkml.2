Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2GJNkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:40:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab2GJNkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:40:03 -0400
Date: Tue, 10 Jul 2012 15:39:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm/hugetlb_cgroup: Add huge_page_order check to
 avoid incorrectly uncharge
Message-ID: <20120710133958.GA20833@tiehlicka.suse.cz>
References: <1341914712-4588-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341914712-4588-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-07-12 18:05:12, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Against linux-next:
> 
> Function alloc_huge_page will call hugetlb_cgroup_charge_cgroup
> to charge pages, the compound page have less than 3 pages will not
> charge to hugetlb cgroup. When alloc_huge_page fails it will call
> hugetlb_cgroup_uncharge_cgroup to uncharge pages, however,
> hugetlb_cgroup_uncharge_cgroup doesn't have huge_page_order check.
> That means it will uncharge pages even if the compound page have less
> than 3 pages. Add huge_page_order check to avoid this incorrectly
> uncharge.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/hugetlb_cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index b834e8d..2b9e214 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -252,6 +252,9 @@ void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>  
>  	if (hugetlb_cgroup_disabled() || !h_cg)
>  		return;
> +
> +	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
> +		return;
>  
>  	res_counter_uncharge(&h_cg->hugepage[idx], csize);
>  	return;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
