Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2EGOBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:01:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab2EGOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:01:07 -0400
Date: Mon, 7 May 2012 16:01:04 +0200
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
Message-ID: <20120507140103.GA4251@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
 <20120427132343.fbb443b9.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
 <20120427143646.8209627e.akpm@linux-foundation.org>
 <87fwbnag6u.fsf@skywalker.in.ibm.com>
 <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
 <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
 <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
 <CABEgKgoNaWtoNN_DOH+KTg7VHYDxVCyekcUC3TBfA313TR0jCw@mail.gmail.com>
 <20120504172420.GF24639@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120504172420.GF24639@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 04-05-12 10:24:20, Tejun Heo wrote:
> Hello,
> 
> (cc'ing Johannes and Michal, hi guys)
> 
> On Fri, May 04, 2012 at 08:17:11AM +0900, Hiroyuki Kamezawa wrote:
> > > Cgroups is moving to a single hierarchy for simplification, this isn't the
> > > only example of where this is currently suboptimal and it would be
> > > disappointing to solidify hugetlb control as part of memcg because of this
> > > current limitation that will be addressed by generic cgroups development.
> > >
> > > Folks, once these things are merged they become an API that can't easily
> > > be shifted around and seperated out later.  The decision now is either to
> > > join hugetlb control with memcg forever when they act in very different
> > > ways or to seperate them so they can be used and configured individually.
> > 
> > How do other guys think ? Tejun ?
> 
> I don't know.  hugetlbfs already is this franken thing which is
> separate from the usual memory management.  It needing cgroup type
> resource limitation feels a bit weird to me.  Isn't this supposed to
> be used in more-or-less tightly controlled setups?  The whole thing
> needs to have its memory cut out from boot after all.
> 
> If someone really has to add cgroup support to hugetlbfs, I'm more
> inclined to say let them play in their own corner unless incorporating
> it into memcg makes it inherently better.

I would agree with you but my impression from the previous (hugetlb)
implementation was that it is much harder to implement the charge moving
if we do not use page_cgroup.
Also the range tracking is rather ugly and clumsy.

> That said, I really don't know that much about mm.  Johannes, Michal,
> what do you guys think?
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
