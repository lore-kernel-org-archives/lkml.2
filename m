Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2GKJRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:17:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2GKJRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:17:44 -0400
Date: Wed, 11 Jul 2012 17:17:14 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/hugetlb_cgroup: Add list_del to remove unused page
 from hugepage_activelist when hugepage migration
Message-ID: <20120711091648.GA10841@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com>
 <87wr2aitpk.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wr2aitpk.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 02:02:23PM +0530, Aneesh Kumar K.V wrote:
>Wanpeng Li <liwp.linux@gmail.com> writes:
>
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>> hugepage_activelist is used to track currently used HugeTLB pages.
>> We can find the in-use HugeTLB pages to support HugeTLB cgroup
>> removal. Don't keep unused page in hugetlb_activelist too long.
>> Otherwise, on cgroup removal we should update the unused page's 
>> charge to parent count. To reduce this overhead, remove unused page 
>> from hugepage_activelist immediately.
>>
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>> ---
>>  mm/hugetlb_cgroup.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>> index b834e8d..d819d66 100644
>> --- a/mm/hugetlb_cgroup.c
>> +++ b/mm/hugetlb_cgroup.c
>> @@ -398,6 +398,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
>>  	spin_lock(&hugetlb_lock);
>>  	h_cg = hugetlb_cgroup_from_page(oldhpage);
>>  	set_hugetlb_cgroup(oldhpage, NULL);
>> +	list_del(&oldhpage->lru);
>>
>>  	/* move the h_cg details to new cgroup */
>>  	set_hugetlb_cgroup(newhpage, h_cg);
>
>put_page on the oldhpage will do that. If we do list_del here
>free_huge_page() will have error list_move().

I don't know if move the page to other lists when migration in order 
to reduce overhead I mentioned make sense. :-)

Regards,
Wanpeng Li

>
>-aneesh
