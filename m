Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693Ab2D0Psu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972Ab2D0Pss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:48:48 -0400
Date: Fri, 27 Apr 2012 11:48:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427154841.GA16237@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427154502.GM27486@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 08:45:02AM -0700, Tejun Heo wrote:
> On Fri, Apr 27, 2012 at 11:40:34AM -0400, Vivek Goyal wrote:
> > On Fri, Apr 27, 2012 at 08:02:17AM -0700, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Fri, Apr 27, 2012 at 10:54:01AM -0400, Jeff Moyer wrote:
> > > > > This patch implements per-blkg request_list.  Each blkg has its own
> > > > > request_list and any IO allocates its request from the matching blkg
> > > > > making blkcgs completely isolated in terms of request allocation.
> > > > 
> > > > So, nr_requests is now actually nr_requests * # of blk cgroups.  Is that
> > > > right?  Are you at all concerned about the amount of memory that can be
> > > > tied up as the number of cgroups increases?
> > > 
> > > Yeah, I thought about it and I don't think there's a single good
> > > solution here.  The other extreme would be splitting nr_requests by
> > > the number of cgroups but that seems even worse - each cgroup should
> > > be able to hit maximum throughput.  Given that a lot of workloads tend
> > > to regulate themselves before hitting nr_requests, I think it's best
> > > to leave it as-is and treat each cgroup as having separate channel for
> > > now.  It's a configurable parameter after all.
> > 
> > So on a slow device a malicious application can easily create thousands
> > of group, queue up tons of IO and create unreclaimable memory easily?
> > Sounds little scary. 
> 
> Malicious application may just jack up nr_requests.

Not an unpriviliged malicious application. In typical cgroup scenario, we
can allow unpriviliged users to create child cgroups so that it can
further subdivide its resources to its children group. (ex. put firefox
in one cgroup, open office in another group etc.).

So it is not same as jack up nr_requests.

Thanks
Vivek
