Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056Ab0GSOlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:41:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51580 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934486Ab0GSOlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:41:03 -0400
Date: Mon, 19 Jul 2010 15:40:47 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background
	writeback
Message-ID: <20100719144046.GR13117@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie> <1279545090-19169-8-git-send-email-mel@csn.ul.ie> <20100719142145.GD12510@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100719142145.GD12510@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:21:45AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 19, 2010 at 02:11:29PM +0100, Mel Gorman wrote:
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > A background flush work may run for ever. So it's reasonable for it to
> > mimic the kupdate behavior of syncing old/expired inodes first.
> > 
> > This behavior also makes sense from the perspective of page reclaim.
> > File pages are added to the inactive list and promoted if referenced
> > after one recycling. If not referenced, it's very easy for pages to be
> > cleaned from reclaim context which is inefficient in terms of IO. If
> > background flush is cleaning pages, it's best it cleans old pages to
> > help minimise IO from reclaim.
> 
> Yes, we absolutely do this. 

Do you mean we absolutely want to do this?

> Wu, do you have an improved version of the
> pending or should we put it in this version for now?
> 

Some insight on how the other writeback changes that are being floated
around might affect the number of dirty pages reclaim encounters would also
be helpful. The tracepoints are there for people to figure it out but any
help figuring it out is useful.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
