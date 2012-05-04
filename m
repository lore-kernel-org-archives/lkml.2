Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2EDRY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:24:27 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:42110 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2EDRY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:24:26 -0400
Date: Fri, 4 May 2012 10:24:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
Message-ID: <20120504172420.GF24639@google.com>
References: <4F9ABF9C.2070707@xenotime.net>
 <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
 <20120427132343.fbb443b9.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
 <20120427143646.8209627e.akpm@linux-foundation.org>
 <87fwbnag6u.fsf@skywalker.in.ibm.com>
 <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
 <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
 <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
 <CABEgKgoNaWtoNN_DOH+KTg7VHYDxVCyekcUC3TBfA313TR0jCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABEgKgoNaWtoNN_DOH+KTg7VHYDxVCyekcUC3TBfA313TR0jCw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Johannes and Michal, hi guys)

On Fri, May 04, 2012 at 08:17:11AM +0900, Hiroyuki Kamezawa wrote:
> > Cgroups is moving to a single hierarchy for simplification, this isn't the
> > only example of where this is currently suboptimal and it would be
> > disappointing to solidify hugetlb control as part of memcg because of this
> > current limitation that will be addressed by generic cgroups development.
> >
> > Folks, once these things are merged they become an API that can't easily
> > be shifted around and seperated out later.  The decision now is either to
> > join hugetlb control with memcg forever when they act in very different
> > ways or to seperate them so they can be used and configured individually.
> 
> How do other guys think ? Tejun ?

I don't know.  hugetlbfs already is this franken thing which is
separate from the usual memory management.  It needing cgroup type
resource limitation feels a bit weird to me.  Isn't this supposed to
be used in more-or-less tightly controlled setups?  The whole thing
needs to have its memory cut out from boot after all.

If someone really has to add cgroup support to hugetlbfs, I'm more
inclined to say let them play in their own corner unless incorporating
it into memcg makes it inherently better.

That said, I really don't know that much about mm.  Johannes, Michal,
what do you guys think?

Thanks.

-- 
tejun
