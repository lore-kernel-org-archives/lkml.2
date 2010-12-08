Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab0LHETt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:19:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab0LHETs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:19:48 -0500
Date: Tue, 7 Dec 2010 20:17:25 -0800
From: Greg KH <gregkh@suse.de>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
Subject: Re: [06/44] numa: fix slab_node(MPOL_BIND)
Message-ID: <20101208041725.GB2291@suse.de>
References: <20101208000640.115606851@clark.site>
 <1291777422.26147.70.camel@zaphod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291777422.26147.70.camel@zaphod>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:03:42PM -0500, Lee Schermerhorn wrote:
> On Tue, 2010-12-07 at 16:04 -0800, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > 
> > commit 800416f799e0723635ac2d720ad4449917a1481c upstream.
> > 
> > When a node contains only HighMem memory, slab_node(MPOL_BIND)
> > dereferences a NULL pointer.
> > 
> > [ This code seems to go back all the way to commit 19770b32609b: "mm:
> >   filter based on a nodemask as well as a gfp_mask".  Which was back in
> >   April 2008, and it got merged into 2.6.26.  - Linus ]
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  mm/mempolicy.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1404,7 +1404,7 @@ unsigned slab_node(struct mempolicy *pol
> >  		(void)first_zones_zonelist(zonelist, highest_zoneidx,
> >  							&policy->v.nodes,
> >  							&zone);
> > -		return zone->node;
> > +		return zone ? zone->node : numa_node_id();
> 
> I think this should be numa_mem_id().  Given the documented purpose of
> slab_node(), we want a node from which page allocation is likely to
> succeed.  numa_node_id() can return a memoryless node for, e.g.,  some
> configurations of some HP ia64 platforms.  numa_mem_id() was introduced
> to return that same node from which "local" mempolicy would allocate
> pages.

So should the upstream patch be changed?

thanks,

greg k-h
