Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2GJRl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:41:28 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43736 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2GJRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:41:26 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH RFC] mm/hugetlb_cgroup: Add huge_page_order check to avoid incorrectly uncharge
In-Reply-To: <1341914712-4588-1-git-send-email-liwp.linux@gmail.com>
References: <1341914712-4588-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 10 Jul 2012 23:11:07 +0530
Message-ID: <87394z1pl8.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12071017-4790-0000-0000-000003A0618A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <liwp.linux@gmail.com> writes:

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

 Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>



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

-aneesh

