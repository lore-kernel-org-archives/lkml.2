Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2FMQhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:37:18 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:42165 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2FMQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:37:16 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 04/15] hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages
In-Reply-To: <20120613145923.GA14777@tiehlicka.suse.cz>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120613145923.GA14777@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 13 Jun 2012 22:07:06 +0530
Message-ID: <871uljnp71.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061316-2674-0000-0000-000004E365B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Wed 13-06-12 15:57:23, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> Use a mmu_gather instead of a temporary linked list for accumulating
>> pages when we unmap a hugepage range
>
> Sorry for coming up with the comment that late but you owe us an
> explanation _why_ you are doing this.
>
> I assume that this fixes a real problem when we take i_mmap_mutex
> already up in 
> unmap_mapping_range
>   mutex_lock(&mapping->i_mmap_mutex);
>   unmap_mapping_range_tree | unmap_mapping_range_list 
>     unmap_mapping_range_vma
>       zap_page_range_single
>         unmap_single_vma
> 	  unmap_hugepage_range
> 	    mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
>
> And that this should have been marked for stable as well (I haven't
> checked when this has been introduced).

Switch to mmu_gather is to get rid of the use of page->lru so that i can use it for
active list.


-aneesh

