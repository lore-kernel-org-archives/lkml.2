Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab2C3Kzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:55:46 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51885 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab2C3Kzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:55:38 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
In-Reply-To: <20120329081003.GC30465@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120328131706.GF20949@tiehlicka.suse.cz> <87sjgs1v6x.fsf@skywalker.in.ibm.com> <20120329081003.GC30465@tiehlicka.suse.cz>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 30 Mar 2012 16:10:00 +0530
Message-ID: <871uoamkxr.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12033010-9574-0000-0000-000002094902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Wed 28-03-12 23:09:34, Aneesh Kumar K.V wrote:
>> Michal Hocko <mhocko@suse.cz> writes:
>> 
>> > On Fri 16-03-12 23:09:25, Aneesh Kumar K.V wrote:
>> >> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> >> 
>> >> This adds necessary charge/uncharge calls in the HugeTLB code
>> >
>> > This begs for more description...
>> > Other than that it looks correct.
>> >
>> 
>> Updated as below
>> 
>>     hugetlb: add charge/uncharge calls for HugeTLB alloc/free
>>     
>>     This adds necessary charge/uncharge calls in the HugeTLB code. We do
>>     memcg charge in page alloc and uncharge in compound page destructor.
>>     We also need to ignore HugeTLB pages in __mem_cgroup_uncharge_common
>>     because that get called from delete_from_page_cache
>
> and from mem_cgroup_end_migration used during soft_offline_page.
>
> Btw., while looking at mem_cgroup_end_migration, I have noticed that you
> need to take care of mem_cgroup_prepare_migration as well otherwise the
> page would get charged as a normal (shmem) page.
>

Won't we skip HugeTLB pages in migrate ? check_range do check for
is_vm_hugetlb_page.

-aneesh

