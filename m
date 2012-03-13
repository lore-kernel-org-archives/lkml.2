Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2CMOD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:03:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab2CMOD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:03:57 -0400
Date: Tue, 13 Mar 2012 10:03:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120313140345.GC29169@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312222817.GI23255@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:28:17PM -0700, Tejun Heo wrote:
> Hey,
> 
> On Mon, Mar 12, 2012 at 11:22:18PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-03-12 at 15:10 -0700, Tejun Heo wrote:
> > > 
> > > * How to map controllers which aren't aware of full hierarchy is still
> > >   an open question but I'm still standing by one active node on any
> > >   root-to-leaf path w/ root group serving as the special rest group. 
> > 
> > What does this mean?
> 
> Let's say we have a tree like the following.
> 
>          root
>       /   |   \
>      G1  G2   G3
>              /  \
> 	   G31  G32
> 
> So, for cgroups which don't support full hierarchy, it'll be viewed as
> either,
> 
>          root
>       /   |   \
>      G1  G2   G3
> 
> or
> 
>           root
>       /   |   |  \
>      G1  G2  G31 G32
> 
> With root being treated specially, probably as just being a equal
> group as other groups, I'm not fully determined about that yet.

So what wrong with flattening the whole hierarchy and all groups being active
in the path? It is not worse then second option?

             root
       /   |  |  |  \
      G1  G2  G3 G31 G32

One problem with above is that a children can create its own child cgroups
and compete at highest level for resources.

But same is the problem with second choice you gave. May be you are
thinking of introducing another knob to configure active point in the
path? I guess that will make cgroup configuration even harder.

May be we flatten the whole hierarchy. When we launch user sessions, we
don't give then permissions to create child cgroups for IO. For services
running with admin priviliges, we still don't have a good solution for
flat controllers. If nobody has a use case, I guess we just live with
that as that's the limitation of flat controller and one needs to make
it hierarchical, if need be.

Thanks
Vivek
