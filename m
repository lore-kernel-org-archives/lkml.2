Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0HWMdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:33:49 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:57549 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752594Ab0HWMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:33:47 -0400
Date: Mon, 23 Aug 2010 22:33:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [2.6.35-rc1, bug] mm: minute-long livelocks in memory reclaim
Message-ID: <20100823123339.GI31488@dastard>
References: <20100822234811.GF31488@dastard>
 <20100823065822.GA22707@localhost>
 <alpine.DEB.2.00.1008230219480.13384@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008230219480.13384@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 02:23:27AM -0700, David Rientjes wrote:
> On Mon, 23 Aug 2010, Wu Fengguang wrote:
> 
> > > I've been testing parallel create workloads over the weekend, and
> > > I've seen this a couple of times now under 8 thread parallel creates
> > > with XFS. I'm running on an 8p VM with 4GB RAM and a fast disk
> > > subsystem. Basically I am seeing the create rate drop to zero
> > > with all 8 CPUs stuck spinning for up to 2 minutes. 'echo t >
> > > /proc/sysrq-trigger' while this is occurring gives the following
> > > trace for all the fs-mark processes:
.....
> 
> You may be interested in Mel's patchset that he just proposed for -mm 
> which identifies watermark variations on machines with high cpu counts 
> (perhaps even eight, as in this report).  The last patch actually reworks 
> this hunk of the code as well.
> 
> 	http://marc.info/?l=linux-mm&m=128255044912938
> 	http://marc.info/?l=linux-mm&m=128255045312950
> 	http://marc.info/?l=linux-mm&m=128255045012942
> 	http://marc.info/?l=linux-mm&m=128255045612954
> 
> Dave, it would be interesting to see if this fixes your problem.

That looks promising - I'll give it a shot, though my test case is
not really what you'd call reproducable(*) so it might take a
couple of days before I can say whether the issue has gone away or
not.

Cheers,

Dave.

(*) create 100 million inodes in parallel using fsmark, collect and
watch behavioural metrics via PCP/pmchart for stuff out of the
ordinary, and dump stack traces, etc when somthing strange occurs.

-- 
Dave Chinner
david@fromorbit.com
