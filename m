Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab0FKSPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:15:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51142 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab0FKSPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:15:50 -0400
Date: Fri, 11 Jun 2010 19:15:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
	and use a_ops->writepages() where possible
Message-ID: <20100611181532.GB9946@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie> <20100608090811.GA5949@infradead.org> <20100608092814.GB27717@csn.ul.ie> <20100611162912.GC24707@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100611162912.GC24707@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:29:12PM -0400, Christoph Hellwig wrote:
> On Tue, Jun 08, 2010 at 10:28:14AM +0100, Mel Gorman wrote:
> > >  - we also need to care about ->releasepage.  At least for XFS it
> > >    can end up in the same deep allocator chain as ->writepage because
> > >    it does all the extent state conversions, even if it doesn't
> > >    start I/O. 
> > 
> > Dang.
> > 
> > >    I haven't managed yet to decode the ext4/btrfs codepaths
> > >    for ->releasepage yet to figure out how they release a page that
> > >    covers a delayed allocated or unwritten range.
> > > 
> > 
> > If ext4/btrfs are also very deep call-chains and this series is going more
> > or less the right direction, then avoiding calling ->releasepage from direct
> > reclaim is one, somewhat unfortunate, option. The second is to avoid it on
> > a per-filesystem basis for direct reclaim using PF_MEMALLOC to detect
> > reclaimers and PF_KSWAPD to tell the difference between direct
> > reclaimers and kswapd.
> 
> I went throught this a bit more and I can't actually hit that code in
> XFS ->releasepage anymore.  I've also audited the caller and can't see
> how we could theoretically hit it anymore.  Do the VM gurus know a case
> where we would call ->releasepage on a page that's actually dirty and
> hasn't been through block_invalidatepage before?
> 

Not a clue I'm afraid as I haven't dealt much with the interactions
between VM and FS in the past. Nick?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
