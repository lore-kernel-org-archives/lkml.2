Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0JQAqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:46:15 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:44616 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756981Ab0JQAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:46:13 -0400
Date: Sun, 17 Oct 2010 11:46:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101017004610.GB29677@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016171213.GC3240@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:12:13AM +1100, Nick Piggin wrote:
> On Sat, Oct 16, 2010 at 12:16:42PM -0400, Christoph Hellwig wrote:
> > On Sat, Oct 16, 2010 at 06:57:03PM +1100, Nick Piggin wrote:
> > > > duplicating these helpers in the dcache code aswell.  IMHO they
> > > > should simple operate directly on the hlist_bl_head, as that's
> > > > what it was designed for.  I also don't really see any point in
> > > > wrapping the hlist_bl_head as inode_hash_bucket.  If the bucket naming
> > > > is important we could rename the hlist_bl stuff to bl_hash, and the
> > > > hlist_bl_head could become bl_hash_bucket.
> > > 
> > > It was done because someone, like -rt, might want more than one bit of
> > > memory to implement a lock. They would have to make a few other
> > > changes, granted, but this helps reduce a lot of churn.
> > > 
> > > I didn't see the point of a layer of dumb wrappers for hlist_bl_head
> > > locking. Just reproducing bit spin and wait locks in wrappers when we
> > > already have good functions for them.
> > 
> > With the changes Dave implemented based on my suggestions we now have
> > an abstract locked hash list data type.  It has the normal hash list
> > operations plus lock/unlock operations.
> 
> That's ugly. It just hides the locking. If a bit of casting bothers
> you then put it in a function where it is used like I did.

I much prefer the abstraction from an end-user point of view. Asking
every developer to understand the intricacies of locking the
hlist_bl structures is asking them to get it wrong. Providing
locking wrappers that are exactly what users need so they don't have
to care about it is, IMO, the right thing to do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
