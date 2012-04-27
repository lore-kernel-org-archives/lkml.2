Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab2D0PCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:02:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391Ab2D0PCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:02:23 -0400
Date: Fri, 27 Apr 2012 08:02:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427150217.GK27486@google.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 10:54:01AM -0400, Jeff Moyer wrote:
> > This patch implements per-blkg request_list.  Each blkg has its own
> > request_list and any IO allocates its request from the matching blkg
> > making blkcgs completely isolated in terms of request allocation.
> 
> So, nr_requests is now actually nr_requests * # of blk cgroups.  Is that
> right?  Are you at all concerned about the amount of memory that can be
> tied up as the number of cgroups increases?

Yeah, I thought about it and I don't think there's a single good
solution here.  The other extreme would be splitting nr_requests by
the number of cgroups but that seems even worse - each cgroup should
be able to hit maximum throughput.  Given that a lot of workloads tend
to regulate themselves before hitting nr_requests, I think it's best
to leave it as-is and treat each cgroup as having separate channel for
now.  It's a configurable parameter after all.

Thanks.

-- 
tejun
