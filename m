Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2INRxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:53:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42569 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab2INRxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:53:21 -0400
Date: Fri, 14 Sep 2012 10:53:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914175316.GE17747@google.com>
References: <20120913205827.GO7677@google.com>
 <1347621302.7172.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347621302.7172.22.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Sep 14, 2012 at 01:15:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-13 at 13:58 -0700, Tejun Heo wrote:
> >   The cpu ones handle nesting correctly - parent's accounting includes
> >   children's, parent's configuration affects children's unless
> >   explicitly overridden, and children's limits nest inside parent's. 
> 
> The implementation has some issues with fixed point math limitations on
> deep hierarchies/large cpu count, but yes.
> 
> Doing soft-float/bignum just isn't going to be popular I guess ;-)

As things currently stand, I think the cpu stuff is high enough bar to
aim for.  That said, I do have some problems with how it handles tasks
vs. groups.  Will talk about in another reply.

> People also don't seem to understand that each extra cgroup carries a
> cost and that nested cgroups are more expensive still, even if the
> intermediate levels are mostly empty (libvirt is a good example of how
> not to do things).
> 
> Anyway, I guess what I'm saying is that we need to work on the awareness
> of cost associated with all this cgroup nonsense, people seem to think
> its all good and free -- or not think at all, which, while depressing,
> seem the more likely option.

The decision may not have been conscious but it seems that we settled
on the direction where cgroup does more hierarchy-wise rather than
leaving non-scalable operations to each use case - e.g. filesystem
trees are very scalable but for that they give up a lot of tree-aware
things like knowing the size of a given subtree.

For what cgroup does, I think the naturally chosen direction is the
right one.  Its functionality inherently requires more involvement
with the tree structure and we of course should try to document the
implications clearly and make things scale better where we can
(e.g. stat propagation has no reason to happen on every update).

Thanks.

-- 
tejun
