Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2CNKmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:42:13 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41941 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2CNKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:42:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
In-Reply-To: <4F5F4C48.8050001@parallels.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F5F4C48.8050001@parallels.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 16:11:58 +0530
Message-ID: <87ty1r8nwp.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031400-6102-0000-0000-000001099EE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 17:31:52 +0400, Glauber Costa <glommer@parallels.com> wrote:
> On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8cac77b..f4aa11c 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2901,6 +2901,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
> >
> >   	if (PageSwapCache(page))
> >   		return NULL;
> > +	/*
> > +	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
> > +	 */
> > +	if (PageHuge(page))
> > +		return NULL;
> 
> Maybe it is better to call uncharge_common from the compound destructor,
> so we can have all the uncharge code in a single place.
> 

PageHuge is not represented by a page flags as SwapCache. Hence I was
not able to call uncharge_common from compound destructor. For
SwapCache, we clear the flag and call uncharge_common again. Also I will
have to update those functions to take the resource counter index as
argument so that we end up updated the right resource counter in the
counter array. That would result in more code changes and I was not sure
about that.

-aneesh

