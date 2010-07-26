Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0GZMAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:00:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:62538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab0GZMAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,261,1278313200"; 
   d="scan'208";a="304344458"
Date: Mon, 26 Jul 2010 20:00:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20100726120011.GG6284@localhost>
References: <20100722050928.653312535@intel.com>
 <20100722061822.906037624@intel.com>
 <20100726105736.GM5300@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726105736.GM5300@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 06:57:37PM +0800, Mel Gorman wrote:
> On Thu, Jul 22, 2010 at 01:09:32PM +0800, Wu Fengguang wrote:
> > A background flush work may run for ever. So it's reasonable for it to
> > mimic the kupdate behavior of syncing old/expired inodes first.
> > 
> > The policy is
> > - enqueue all newly expired inodes at each queue_io() time
> > - retry with halfed expire interval until get some inodes to sync
> > 
> > CC: Jan Kara <jack@suse.cz>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Ok, intuitively this would appear to tie into pageout where we want
> older inodes to be cleaned first by background flushers to limit the
> number of dirty pages encountered by page reclaim. If this is accurate,
> it should be detailed in the changelog.

Good suggestion. I'll add these lines:

This is to help reduce the number of dirty pages encountered by page
reclaim, eg. the pageout() calls. Normally older inodes contain older
dirty pages, which are more close to the end of the LRU lists. So
syncing older inodes first helps reducing the dirty pages reached by
the page reclaim code.

Thanks,
Fengguang
