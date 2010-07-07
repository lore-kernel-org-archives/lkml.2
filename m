Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0GGJue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 05:50:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39959 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab0GGJu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 05:50:27 -0400
Date: Wed, 7 Jul 2010 10:50:10 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100707095010.GK13780@csn.ul.ie>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie> <1277811288-5195-13-git-send-email-mel@csn.ul.ie> <20100702125155.69c02f85.akpm@linux-foundation.org> <20100705134949.GC13780@csn.ul.ie> <20100707050338.GA5039@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100707050338.GA5039@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 01:03:38PM +0800, Wu Fengguang wrote:
> Hi Mel,
> 
> > Second, using systemtap, I was able to see that file-backed dirty
> > pages have a tendency to be near the end of the LRU even though they
> > are a small percentage of the overall pages in the LRU. I'm hoping
> > to figure out why this is as it would make avoiding writeback a lot
> > less controversial.
> 
> Your intuitions are correct -- the current background writeback logic
> fails to write elder inodes first. Under heavy loads the background
> writeback job may run for ever, totally ignoring the time order of
> inode->dirtied_when. This is probably why you see lots of dirty pages
> near the end of LRU.
> 

Possible. In a mail to Christoph, I asserted that writeback of elder inodes
was happening first but I obviously could be mistaken.

> Here is an old patch for fixing this. Sorry for being late. I'll
> pick up and refresh the patch series ASAP.  (I made a mistake last
> year to post too many patches at one time. I'll break them up into
> more manageable pieces.)
> 
> [PATCH 31/45] writeback: sync old inodes first in background writeback
> <https://kerneltrap.org/mailarchive/linux-fsdevel/2009/10/7/6476313>
> 

I'll check it out as an alternative to forward-flushing based on the
amount of dirty pages encountered during scanning. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
