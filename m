Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1EMDgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:36:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:9393 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab1EMDgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:36:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="435375345"
Date: Fri, 13 May 2011 11:36:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110513033605.GC8016@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140031.025181367@intel.com>
 <20110512224420.GJ19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512224420.GJ19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:44:20AM +0800, Dave Chinner wrote:
> On Thu, May 12, 2011 at 09:57:09PM +0800, Wu Fengguang wrote:
> > The flusher works on dirty inodes in batches, and may quit prematurely
> > if the batch of inodes happen to be metadata-only dirtied: in this case
> > wbc->nr_to_write won't be decreased at all, which stands for "no pages
> > written" but also mis-interpreted as "no progress".
> > 
> > So introduce writeback_control.inodes_cleaned to count the inodes get
> > cleaned.  A non-zero value means there are some progress on writeback,
> > in which case more writeback can be tried.
> 
> Why introduce a new field for this?

Yeah sorry, but this is an intermediate field that will be removed in
patch 14.

> Just decrement nr_to_write for every write_inode() call made in
> writeback_single_inode()....

There are two problems

- nr_to_write has always been "# of pages written" and writeback_sb_inodes()
  is actually making use of it to do page accounting in work->nr_pages.

- write_inode() does not always succeed, and its return value is not
  reliable on every filesystem.. (I actually tried this approach in v1
  and found sync(1) hang on NFS)

Thanks,
Fengguang
