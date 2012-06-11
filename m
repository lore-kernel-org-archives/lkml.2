Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2FKJc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:32:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2FKJc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:32:28 -0400
Date: Mon, 11 Jun 2012 11:32:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        mgorman@suse.de, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        dhillf@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Message-ID: <20120611093225.GA14523@tiehlicka.suse.cz>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
 <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com>
 <20120608160612.dea6d1ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608160612.dea6d1ce.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-06-12 16:06:12, Andrew Morton wrote:
> On Wed, 30 May 2012 20:13:31 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > >> 
> > >>  - code: seperating hugetlb bits out from memcg bits to avoid growing 
> > >>    mm/memcontrol.c beyond its current 5650 lines, and
> > >> 
> > >
> > > I can definitely look at spliting mm/memcontrol.c 
> > >
> > >
> > >>  - performance: not incurring any overhead of enabling memcg for per-
> > >>    page tracking that is unnecessary if users only want to limit hugetlb 
> > >>    pages.
> > >> 
> > 
> > Since Andrew didn't sent the patchset to Linus because of this
> > discussion, I looked at reworking the patchset as a seperate
> > controller. The patchset I sent here
> > 
> > http://thread.gmane.org/gmane.linux.kernel.mm/79230
> > 
> > have seen minimal testing. I also folded the fixup patches
> > Andrew had in -mm to original patchset.
> > 
> > Let me know if the changes looks good.
> 
> This is starting to be a problem.  I'm still sitting on the old version
> of this patchset and it will start to get in the way of other work.
> 
> We now have this new version of the patchset which implements a
> separate controller but it is unclear to me which way we want to go.
 
I guess you are talking about v7 which is mem_cgroup based. This one has
some drawbacks (e.g. the most user visible one is that if one wants to
disable memory overhead from memcg he has to disable hugetlb controller
as well).
v8 took a different approach ((ab)use lru.next on the 3rd page to store
the group pointer) which looks as a reasonable compromise.

> Can the memcg developers please drop everything else and make a
> decision here?

I think that v8 (+fixups) is the way to go.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
