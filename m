Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1HCNpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:45:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1HCNpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:45:11 -0400
Date: Wed, 3 Aug 2011 14:45:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 4/8] btrfs: Warn if direct reclaim tries to writeback
 pages
Message-ID: <20110803134507.GI19099@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-5-git-send-email-mgorman@suse.de>
 <20110803111031.GC27199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110803111031.GC27199@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 01:10:31PM +0200, Johannes Weiner wrote:
> On Thu, Jul 21, 2011 at 05:28:46PM +0100, Mel Gorman wrote:
> > Direct reclaim should never writeback pages. Warn if an attempt is
> > made. By rights, btrfs should be allowing writepage from kswapd if
> > it is failing to reclaim pages by any other means but it's outside
> > the scope of this patch.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  fs/btrfs/disk-io.c |    2 ++
> >  fs/btrfs/inode.c   |    2 ++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 1ac8db5d..cc9c9cf 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -829,6 +829,8 @@ static int btree_writepage(struct page *page, struct writeback_control *wbc)
> >  
> >  	tree = &BTRFS_I(page->mapping->host)->io_tree;
> >  	if (!(current->flags & PF_MEMALLOC)) {
> > +		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
> > +								PF_MEMALLOC);
> 
> Since it is branch for PF_MEMALLOC being set, why not just
> WARN_ON_ONCE(!(current->flags & PF_KSWAPD)) instead?
> 
> Minor nitpick, though, and I can understand if you just want to have
> the conditionals be the same in every fs.
> 

It was just copying the conditionals for the other FS although I admit
your version would look nicer.

-- 
Mel Gorman
SUSE Labs
