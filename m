Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1GNPtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:49:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1GNPtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:49:20 -0400
Date: Thu, 14 Jul 2011 16:49:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/5] mm: writeback: Prioritise dirty inodes encountered
 by direct reclaim for background flushing
Message-ID: <20110714154915.GV7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
 <1310567487-15367-6-git-send-email-mgorman@suse.de>
 <20110714150959.GA30936@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110714150959.GA30936@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 11:09:59AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 13, 2011 at 03:31:27PM +0100, Mel Gorman wrote:
> > It is preferable that no dirty pages are dispatched from the page
> > reclaim path. If reclaim is encountering dirty pages, it implies that
> > either reclaim is getting ahead of writeback or use-once logic has
> > prioritise pages for reclaiming that are young relative to when the
> > inode was dirtied.
> 
> what does this buy us? 

Very little. The vague intention was to avoid a situation where kswapds
priority was raised such that it had to write pages to clean a
particular zone.

> If at all we should prioritize by a zone,
> e.g. tell write_cache_pages only to bother with writing things out
> if the dirty page is in a given zone.   We'd probably still cluster
> around it to make sure we get good I/O patterns, but would only start
> I/O if it has a page we actually care about.
> 

That would make more sense. I've dropped this patch entirely.

-- 
Mel Gorman
SUSE Labs
