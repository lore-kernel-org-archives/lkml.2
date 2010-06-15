Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0FOLUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:20:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0FOLUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:20:22 -0400
Date: Tue, 15 Jun 2010 21:20:18 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615112018.GL6138@laptop>
References: <20100614231144.GG6590@dastard>
 <20100614162143.04783749.akpm@linux-foundation.org>
 <20100615003943.GK6590@dastard>
 <20100614183957.ad0cdb58.akpm@linux-foundation.org>
 <20100615032034.GR6590@dastard>
 <20100614211515.dd9880dc.akpm@linux-foundation.org>
 <20100615063643.GS6590@dastard>
 <20100615102822.GA4010@ioremap.net>
 <20100615105538.GI6138@laptop>
 <20100615111026.GF31051@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615111026.GF31051@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 07:10:26AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 15, 2010 at 08:55:38PM +1000, Nick Piggin wrote:
> > 
> > What I do in fsblock is to maintain a block-nr sorted tree of dirty
> > blocks. This works nicely because fsblock dirty state is properly
> > synchronized with page dirty state. So writeout can just walk this in
> > order and it provides pretty optimal submission pattern of any
> > interleavings of data and metadata. No need for buffer boundary or
> > hacks like that. (needs some intelligence for delalloc, though).
> 
> I think worrying about indirect blocks really doesn't matter much
> these days.  For one thing extent based filesystems have a lot less
> of these, and second for a journaling filesystem we only need to log
> modification to the indirect blocks and not actually write them back
> in place during the sync.  At least for XFS the actual writeback can
> happen a lot later, as part of the ordered list of delwri buffers.

That's true, more importantly I meant any interleavings of data from
more than one file too.

