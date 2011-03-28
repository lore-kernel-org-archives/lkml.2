Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1C1Vx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:53:59 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39193 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543Ab1C1Vx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:53:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkEADYBkU15LK5JgWdsb2JhbAClQxUBARYmJcVxDYVcBA
Date: Tue, 29 Mar 2011 08:53:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Lepikhin <johnlepikhin@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: Very aggressive memory reclaim
Message-ID: <20110328215344.GC3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc xfs and mm lists]

On Mon, Mar 28, 2011 at 08:39:29PM +0400, John Lepikhin wrote:
> Hello,
> 
> I use high-loaded machine with 10M+ inodes inside XFS, 50+ GB of
> memory, intensive HDD traffic and 20..50 forks per second. Vanilla
> kernel 2.6.37.4. The problem is that kernel frees memory very
> aggressively.
> 
> For example:
> 
> 25% of memory is used by processes
> 50% for page caches
> 7% for slabs, etc.
> 18% free.
> 
> That's bad but works. After few hours:
> 
> 25% of memory is used by processes
> 62% for page caches
> 7% for slabs, etc.
> 5% free.
> 
> Most of files are cached, works perfectly. This is the moment when
> kernel decides to free some memory. After memory reclaim:
> 
> 25% of memory is used by processes
> 25% for page caches(!)
> 7% for slabs, etc.
> 43% free(!)
> 
> Page cache is dropped, server becomes too slow. This is the beginning
> of new cycle.
> 
> I didn't found any huge mallocs at that moment. Looks like because of
> large number of small mallocs (forks) kernel have pessimistic forecast
> about future memory usage and frees too much memory. Is there any
> options of tuning this? Any other variants?

First it would be useful to determine why the VM is reclaiming so
much memory. If it is somewhat predictable when the excessive
reclaim is going to happen, it might be worth capturing an event
trace from the VM so we can see more precisely what it is doiing
during this event. In that case, recording the kmem/* and vmscan/*
events is probably sufficient to tell us what memory allocations
triggered reclaim and how much reclaim was done on each event.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
