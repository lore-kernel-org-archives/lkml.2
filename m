Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab2FOWb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:31:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46656 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab2FOWby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:31:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206110220290.6843@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
 <20120527202848.GC7631@skywalker.linux.vnet.ibm.com> <87lik920h8.fsf@skywalker.in.ibm.com>
 <20120608160612.dea6d1ce.akpm@linux-foundation.org> <4FD56C19.4060307@jp.fujitsu.com>
 <alpine.DEB.2.00.1206110220290.6843@chino.kir.corp.google.com>
From: Aditya Kali <adityakali@google.com>
Date: Fri, 15 Jun 2012 15:31:32 -0700
Message-ID: <CAGr1F2EzDc3Ypv6twFE8Ua-JZUEkEVQJOPKwLt0O56c2-PycvA@mail.gmail.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
To: David Rientjes <rientjes@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 2:23 AM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 11 Jun 2012, Kamezawa Hiroyuki wrote:
>
>> Now, I think...
>>
>>   1. I need to agree that overhead is _not_ negligible.
>>
>>   2. THP should be the way rather than hugetlb for my main target platform.
>>      (shmem/tmpfs should support THP. we need study.)
>>      user-experience should be fixed by THP+tmpfs+memcg.
>>
>>   3. It seems Aneesh decided to have independent hugetlb cgroup.
>>
>> So, now, I admit to have independent hugetlb cgroup.
>> Other opinions ?
>>
>
> I suggested the seperate controller in the review of the patchset so I
> obviously agree with your conclusion.  I don't think we should account for
> hugetlb pages in memory.usage_in_bytes and enforce memory.limit_in_bytes
> since 512 4K pages is not the same as 1 2M page which may be a sacred
> resource if fragmentation is high.
>
Based on the usecase at Google, I see a definite value in including
hugepage usage in memory.usage_in_bytes as well and having a single
limit for memory usage for the job. Our jobs wants to specify only one
(total) memory limit (including slab usage, and other kernel memory
usage, hugepages, etc.).

The hugepage/smallpage requirements of the job vary during its
lifetime. Having two different limits means less flexibility for jobs
as they now have to specify their limit as (max_hugepage,
max_smallpage) instead of max(hugepage + smallpage). Two limits
complicates the API for the users and requires them to over-specify
the resources.

> Many thanks to Aneesh for continuing to update the patchset and working
> toward a resolution on this, I love the direction its taking.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

Thanks,
-- 
Aditya
