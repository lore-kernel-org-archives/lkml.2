Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1DSGil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:38:41 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38140 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab1DSGij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:38:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMEAHQsrU15LHHJgWdsb2JhbAClQhUBARYmJYhvvR0OhWME
Date: Tue, 19 Apr 2011 16:38:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 0/6] writeback: moving expire targets for
 background/kupdate works
Message-ID: <20110419063823.GD23985@dastard>
References: <20110419030003.108796967@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419030003.108796967@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:00:03AM +0800, Wu Fengguang wrote:
> 
> Andrew,
> 
> This aims to reduce possible pageout() calls by making the flusher
> concentrate a bit more on old/expired dirty inodes.

In what situation is this a problem? Can you demonstrate how you
trigger it? And then how much improvement does this patchset make?

> Patches 04, 05 have been updated since last post, please review.
> The concerns from last review have been addressed.
> 
> It runs fine on simple workloads over ext3/4, xfs, btrfs and NFS.

But it starts propagating new differences between background and
kupdate style writeback. We've been trying to reduce the number of
permutations of writeback behaviour, so it seems to me to be wrong
to further increase the behavioural differences. Indeed, why do we
need "for kupdate" style writeback and "background" writeback
anymore - can' we just use background style writeback for both?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
