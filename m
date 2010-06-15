Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0FONIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:08:18 -0400
Received: from THUNK.ORG ([69.25.196.29]:59674 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab0FONIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:08:16 -0400
Date: Tue, 15 Jun 2010 09:07:39 -0400
From: tytso@mit.edu
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615130739.GM6666@thunk.org>
Mail-Followup-To: tytso@mit.edu, Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christoph Hellwig <hch@infradead.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
 <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
 <20100614231144.GG6590@dastard>
 <20100614162143.04783749.akpm@linux-foundation.org>
 <20100615003943.GK6590@dastard>
 <20100614183957.ad0cdb58.akpm@linux-foundation.org>
 <20100615032034.GR6590@dastard>
 <20100614211515.dd9880dc.akpm@linux-foundation.org>
 <20100615114342.GD26788@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615114342.GD26788@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 12:43:42PM +0100, Mel Gorman wrote:
> 
> I'll do this just to see what it looks like. To be frank, I lack
> taste when it comes to how the block layer and filesystem should
> behave so am having troube deciding if sorting the pages prior to
> submission is a good thing or if it would just encourage bad or lax
> behaviour in the IO submission queueing.
> 

I suspect the right answer is we need to sort both at the block layer
and either (a) before you pass things to the filesystem layer, or if
you don't do that (b) the filesystem will be forced to do its own
queuing/sorting at the very least for delayed allocation pages, so the
allocator can do something sane.  And given that there are multiple
file systems that support delayed allocation, it would be nice if this
could be recognized by the writeback code, as opposed to having btrfs,
xfs, ext4, all having to implement something very similar at the fs
layer.

							- Ted
