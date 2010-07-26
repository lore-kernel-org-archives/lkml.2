Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0GZMVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:21:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:33772 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0GZMVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:21:20 -0400
Date: Mon, 26 Jul 2010 14:20:54 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20100726122054.GF3280@quack.suse.cz>
References: <20100722050928.653312535@intel.com>
 <20100722061822.906037624@intel.com>
 <20100726105736.GM5300@csn.ul.ie>
 <20100726120011.GG6284@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726120011.GG6284@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-07-10 20:00:11, Wu Fengguang wrote:
> On Mon, Jul 26, 2010 at 06:57:37PM +0800, Mel Gorman wrote:
> > On Thu, Jul 22, 2010 at 01:09:32PM +0800, Wu Fengguang wrote:
> > > A background flush work may run for ever. So it's reasonable for it to
> > > mimic the kupdate behavior of syncing old/expired inodes first.
> > > 
> > > The policy is
> > > - enqueue all newly expired inodes at each queue_io() time
> > > - retry with halfed expire interval until get some inodes to sync
> > > 
> > > CC: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > Ok, intuitively this would appear to tie into pageout where we want
> > older inodes to be cleaned first by background flushers to limit the
> > number of dirty pages encountered by page reclaim. If this is accurate,
> > it should be detailed in the changelog.
> 
> Good suggestion. I'll add these lines:
> 
> This is to help reduce the number of dirty pages encountered by page
> reclaim, eg. the pageout() calls. Normally older inodes contain older
> dirty pages, which are more close to the end of the LRU lists. So
  Well, this kind of implicitely assumes that once page is written, it
doesn't get accessed anymore, right? Which I imagine is often true but
not for all workloads... Anyway I think this behavior is a good start
also because it is kind of natural to users to see "old" files written
first.

> syncing older inodes first helps reducing the dirty pages reached by
> the page reclaim code.

								Honza  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
