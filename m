Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab1EJNwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:52:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:34246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1EJNwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:52:02 -0400
Date: Tue, 10 May 2011 15:52:00 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 03/17] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110510135200.GH4402@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031612.167620443@intel.com>
 <20110506143614.GF18982@quack.suse.cz>
 <20110510022336.GB6758@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510022336.GB6758@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-05-11 10:23:36, Wu Fengguang wrote:
> On Fri, May 06, 2011 at 10:36:14PM +0800, Jan Kara wrote:
> > On Fri 06-05-11 11:08:24, Wu Fengguang wrote:
> > > The flusher works on dirty inodes in batches, and may quit prematurely
> > > if the batch of inodes happen to be metadata-only dirtied: in this case
> > > wbc->nr_to_write won't be decreased at all, which stands for "no pages
> > > written" but also mis-interpreted as "no progress".
> > > 
> > > So introduce writeback_control.inodes_cleaned to count the inodes get
> > > cleaned.  A non-zero value means there are some progress on writeback,
> > > in which case more writeback can be tried.
> > > 
> > > about v1: The initial version was to count successful ->write_inode()
> > > calls.  However it leads to busy loops for sync() over NFS, because NFS
> > > ridiculously returns 0 (success) while at the same time redirties the
> > > inode.  The NFS case can be trivially fixed, however there may be more
> > > hidden bugs in other filesystems..
> >   I think Christoph didn't like this patch
> > (https://lkml.org/lkml/2011/5/4/123) and suggested that inodes_cleaned
> > should remain local to fs-writeback.c...
> 
> Yes, he didn't like introducing one more field to writeback_control,
> which will be removed in patch 14. (It will be a lot of fuss to move
> patch 14 here or move this logic after patch 14.)
  Yes, I've noticed (after I've sent this email) that you eventually remove
the code later in the series :). So I wonder would it be that much work to
just drop this patch? It's kind of dumb to add a new code which is removed
a few patches later. But I'm stopping bitching about this now ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
