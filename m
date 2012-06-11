Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2FKPfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:35:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39216 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2FKPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:35:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
In-Reply-To: <20120611125952.GM12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611083810.GC12402@tiehlicka.suse.cz> <87liju5h9u.fsf@skywalker.in.ibm.com> <20120611125952.GM12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 21:05:30 +0530
Message-ID: <878vftvp31.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061105-9264-0000-0000-000001AF5FDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Mon 11-06-12 14:58:45, Aneesh Kumar K.V wrote:
>> Michal Hocko <mhocko@suse.cz> writes:
>> 
>> > On Sat 09-06-12 14:29:56, Aneesh Kumar K.V wrote:
>> >> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> >> 
>> >> This patchset add the charge and uncharge routines for hugetlb cgroup.
>> >> This will be used in later patches when we allocate/free HugeTLB
>> >> pages.
>> >
>> > Please describe the locking rules.
>> 
>> All the update happen within hugetlb_lock.
>
> Yes, I figured but it is definitely worth mentioning in the patch
> description.

Done.

>
> [...]
>> >> +void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>> >> +				  struct hugetlb_cgroup *h_cg,
>> >> +				  struct page *page)
>> >> +{
>> >> +	if (hugetlb_cgroup_disabled() || !h_cg)
>> >> +		return;
>> >> +
>> >> +	spin_lock(&hugetlb_lock);
>> >> +	if (hugetlb_cgroup_from_page(page)) {
>> >
>> > How can this happen? Is it possible that two CPUs are trying to charge
>> > one page?
>> 
>> That is why I added that. I looked at the alloc_huge_page, and I
>> don't see we would end with same page from different CPUs but then
>> we have similar checks in memcg, where we drop the charge if we find
>> the page cgroup already used.
>
> Yes but memcg is little bit more complicated than hugetlb which has
> which doesn't have to cope with async charges. Hugetlb allocation is
> serialized by hugetlb_lock so only one caller gets the page.
> I do not think the check is required here or add a comment explaining
> how it can happen.
>

updated.

-aneesh

