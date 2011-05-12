Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1ELWoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:44:25 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:48594 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850Ab1ELWoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:44:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIxfzE15LCoe/2dsb2JhbACleHjITw6GBwSXIIdX
Date: Fri, 13 May 2011 08:44:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110512224420.GJ19446@dastard>
References: <20110512135706.937596128@intel.com>
 <20110512140031.025181367@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512140031.025181367@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:57:09PM +0800, Wu Fengguang wrote:
> The flusher works on dirty inodes in batches, and may quit prematurely
> if the batch of inodes happen to be metadata-only dirtied: in this case
> wbc->nr_to_write won't be decreased at all, which stands for "no pages
> written" but also mis-interpreted as "no progress".
> 
> So introduce writeback_control.inodes_cleaned to count the inodes get
> cleaned.  A non-zero value means there are some progress on writeback,
> in which case more writeback can be tried.

Why introduce a new field for this? Just decrement nr_to_write for
every write_inode() call made in writeback_single_inode()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
