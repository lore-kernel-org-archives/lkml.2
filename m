Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab2CNKWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:22:13 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59182 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682Ab2CNKWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:22:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 2/8] memcg: Add HugeTLB extension
In-Reply-To: <20120313143316.0ef74d0e.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313143316.0ef74d0e.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 15:51:50 +0530
Message-ID: <87zkbj8ou9.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031410-2000-0000-0000-000006C2098E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 14:33:16 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 13 Mar 2012 12:37:06 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > +static int mem_cgroup_hugetlb_usage(struct mem_cgroup *memcg)
> > +{
> > +	int idx;
> > +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
> > +		if (memcg->hugepage[idx].usage > 0)
> > +			return memcg->hugepage[idx].usage;
> > +	}
> > +	return 0;
> > +}
> 
> Please document the function?  Had you done this, I might have been
> able to work out why the function bales out on the first used hugepage
> size, but I can't :(

I guess the function is named wrongly. I will rename it to
mem_cgroup_have_hugetlb_usage() in the next iteration ? The function
will return (bool) 1 if it has any hugetlb resource usage.

> 
> This could have used for_each_hstate(), had that macro been better
> designed (or updated).
> 

Can you explain this ?. for_each_hstate allows to iterate over
different hstates. But here we need to look at different hugepage
rescounter in memcg. I can still use for_each_hstate() and find the
hstate index (h - hstates) and use that to index memcg rescounter
array. But that would make it more complex ?

> Upon return this function coerces an unsigned long long into an "int". 
> We decided last week that more than 2^32 hugepages was not
> inconceivable, so I guess that's a bug.
> 

-aneesh

