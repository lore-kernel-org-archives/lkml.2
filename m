Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1FSPzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:55:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:44142 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1FSPzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:55:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="16871466"
Date: Sun, 19 Jun 2011 23:55:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: introduce smoothed global dirty limit
Message-ID: <20110619155546.GA14338@localhost>
References: <20110619150108.691351746@intel.com>
 <20110619150510.246140117@intel.com>
 <20110619153636.GC20424@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619153636.GC20424@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 11:36:37PM +0800, Christoph Hellwig wrote:
> On Sun, Jun 19, 2011 at 11:01:11PM +0800, Wu Fengguang wrote:
> > The start of a heavy weight application (ie. KVM) may instantly knock
> > down determine_dirtyable_memory() and hence the global/bdi dirty
> > thresholds.
> > 
> > So introduce global_dirty_limit for tracking the global dirty threshold
> > with policies
> > 
> > - follow downwards slowly
> > - follow up in one shot
> > 
> > global_dirty_limit can effectively mask out the impact of sudden drop of
> > dirtyable memory. It will be used in the next patch for two new type of
> > dirty limits.
> 
> This needs to be explained in more detail in comments near the actual
> code.

Good point! This is the added comment for the update_dirty_limit() function.

/*
 * The global dirtyable memory and dirty threshold could be suddenly knocked
 * down by a large amount (eg. on the startup of KVM). This may throw the
 * system into deep dirty exceeded state and throttled to "death" for a couple
 * of seconds. The solution is to maintain global_dirty_limit for tracking
 * slowly down to the knocked down dirty threshold.
 */
static void update_dirty_limit(unsigned long thresh,
                               unsigned long dirty)

Thanks,
Fengguang
