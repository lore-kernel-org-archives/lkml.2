Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031261Ab2CNXnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:43:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031233Ab2CNXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:43:36 -0400
Date: Wed, 14 Mar 2012 16:43:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 2/8] memcg: Add HugeTLB extension
Message-Id: <20120314164334.5e35f3b6.akpm@linux-foundation.org>
In-Reply-To: <87zkbj8ou9.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120313143316.0ef74d0e.akpm@linux-foundation.org>
	<87zkbj8ou9.fsf@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 15:51:50 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Tue, 13 Mar 2012 14:33:16 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 13 Mar 2012 12:37:06 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > +static int mem_cgroup_hugetlb_usage(struct mem_cgroup *memcg)
> > > +{
> > > +	int idx;
> > > +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
> > > +		if (memcg->hugepage[idx].usage > 0)
> > > +			return memcg->hugepage[idx].usage;
> > > +	}
> > > +	return 0;
> > > +}
> > 
> > Please document the function?  Had you done this, I might have been
> > able to work out why the function bales out on the first used hugepage
> > size, but I can't :(
> 
> I guess the function is named wrongly. I will rename it to
> mem_cgroup_have_hugetlb_usage() in the next iteration ? The function
> will return (bool) 1 if it has any hugetlb resource usage.
> 
> > 
> > This could have used for_each_hstate(), had that macro been better
> > designed (or updated).
> > 
> 
> Can you explain this ?. for_each_hstate allows to iterate over
> different hstates. But here we need to look at different hugepage
> rescounter in memcg. I can still use for_each_hstate() and find the
> hstate index (h - hstates) and use that to index memcg rescounter
> array. But that would make it more complex ?

If the for_each_hstate() macro took an additional arg which holds the
base address of the array, that macro could have been used here.

Or perhaps not - I didn't look too closely ;)  It isn't important.
