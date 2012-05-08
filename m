Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2EHKsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:48:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2EHKsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:48:47 -0400
Date: Tue, 8 May 2012 12:48:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
Message-ID: <20120508104844.GB4818@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
 <20120427143646.8209627e.akpm@linux-foundation.org>
 <87fwbnag6u.fsf@skywalker.in.ibm.com>
 <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
 <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
 <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
 <CABEgKgoNaWtoNN_DOH+KTg7VHYDxVCyekcUC3TBfA313TR0jCw@mail.gmail.com>
 <20120504172420.GF24639@google.com>
 <20120507140103.GA4251@tiehlicka.suse.cz>
 <20120507170840.GA19417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507170840.GA19417@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-05-12 10:08:40, Tejun Heo wrote:
> Hello,
> 
> On Mon, May 07, 2012 at 04:01:04PM +0200, Michal Hocko wrote:
> > > If someone really has to add cgroup support to hugetlbfs, I'm more
> > > inclined to say let them play in their own corner unless incorporating
> > > it into memcg makes it inherently better.
> > 
> > I would agree with you but my impression from the previous (hugetlb)
> > implementation was that it is much harder to implement the charge moving
> > if we do not use page_cgroup.
> > Also the range tracking is rather ugly and clumsy.
> 
> Understood.  I haven't looked at the code, so my opinion was based on
> the assumption that the whole thing is completely separate (in design
> and implementation) from memcg as hugtlbfs is from the usual mm.  If
> it's better / easier implemented together with memcg, I have no
> objection to making it part of memcg.

I think we could still consider a possibility of using page_cgroup for
tracking without the rest of memcg infrastructure (charging) in place.
It sounds like the memory overhead would be too big (at least now) for
relatively few hugetlb pages in use but it would reduce the performance
hit if a user is interested only in the hugetlb limits (mentioned by
David in the other email).
On the other hand we are on the way to get rid of page_cgroup and push
the missing parts into the struct page. Then we could accomplish the
hugetlb only use case by cgroup_disable=memory hugetlbaccount=1 kernel
parameters (yes still not very nice...).
That being said I think that going memcg way is simpler and that the
!memcg && hugetlb use case is still possible (somehow).

Or does anybody have a different idea?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
