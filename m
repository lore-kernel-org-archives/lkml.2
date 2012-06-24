Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2FXQpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:45:05 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34739 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2FXQpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:45:03 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
In-Reply-To: <20120622151121.917178eb.akpm@linux-foundation.org>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD9A79D.9030303@huawei.com> <20120622151121.917178eb.akpm@linux-foundation.org>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 24 Jun 2012 22:14:51 +0530
Message-ID: <87txy07j7g.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12062416-5816-0000-0000-0000034A0DD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Andrew,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 14 Jun 2012 16:58:05 +0800
> Li Zefan <lizefan@huawei.com> wrote:
>
>> > +int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
>> 
>> > +				 struct hugetlb_cgroup **ptr)
>> > +{
>> > +	int ret = 0;
>> > +	struct res_counter *fail_res;
>> > +	struct hugetlb_cgroup *h_cg = NULL;
>> > +	unsigned long csize = nr_pages * PAGE_SIZE;
>> > +
>> > +	if (hugetlb_cgroup_disabled())
>> > +		goto done;
>> > +	/*
>> > +	 * We don't charge any cgroup if the compound page have less
>> > +	 * than 3 pages.
>> > +	 */
>> > +	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
>> > +		goto done;
>> > +again:
>> > +	rcu_read_lock();
>> > +	h_cg = hugetlb_cgroup_from_task(current);
>> > +	if (!h_cg)
>> 
>> 
>> In no circumstances should h_cg be NULL.
>> 
>
> Aneesh?

I missed this in the last review. Thanks for reminding. I will send a
patch addressing this and another related comment in
4FD9A6B6.50503@huawei.com as a separate mail.

-aneesh

