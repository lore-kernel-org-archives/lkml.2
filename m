Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1HCOfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:35:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1HCOfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:35:32 -0400
Date: Wed, 3 Aug 2011 15:35:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803143527.GM19099@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-4-git-send-email-mgorman@suse.de>
 <20110803105819.GA27199@redhat.com>
 <20110803110629.GB27199@redhat.com>
 <20110803134420.GH19099@suse.de>
 <20110803140019.GA31026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110803140019.GA31026@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 04:00:19PM +0200, Johannes Weiner wrote:
> On Wed, Aug 03, 2011 at 02:44:20PM +0100, Mel Gorman wrote:
> > On Wed, Aug 03, 2011 at 01:06:29PM +0200, Johannes Weiner wrote:
> > > On Wed, Aug 03, 2011 at 12:58:19PM +0200, Johannes Weiner wrote:
> > > > On Thu, Jul 21, 2011 at 05:28:45PM +0100, Mel Gorman wrote:
> > > > > Direct reclaim should never writeback pages. Warn if an attempt
> > > > > is made.
> > > > > 
> > > > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > > > 
> > > > Acked-by: Johannes Weiner <jweiner@redhat.com>
> > > 
> > > Oops, too fast.
> > > 
> > > Shouldn't the WARN_ON() be at the top of the function, rather than
> > > just warn when the write is deferred due to delalloc?
> > 
> > I thought it made more sense to put the warning at the point where ext4
> > would normally ignore ->writepage.
> > 
> > That said, in my current revision of the series, I've dropped these
> > patches altogether as page migration should be able to trigger the same
> > warnings but be called from paths that are of less concern for stack
> > overflows (or at the very least be looked at as a separate series).
> 
> Doesn't this only apply to btrfs which has no own .migratepage aop for
> file pages?  The others use buffer_migrate_page.
> 

Bah, you're right. It was btrfs I was looking at during the time I
decided to drop the patches and I didn't think it through. I only
needed to drop the btrfs one.

> But if you dropped them anyway, it does not matter :)

I put back in the xfs and ext4 checks. The ext4 check is still in the
same place.

-- 
Mel Gorman
SUSE Labs
