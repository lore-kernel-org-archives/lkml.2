Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab0GOArd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:47:33 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:36473 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757910Ab0GOArb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:47:31 -0400
Date: Thu, 15 Jul 2010 10:46:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: Tree for July 7
Message-ID: <20100715004639.GG30737@dastard>
References: <20100707165539.957e7d1c.sfr@canb.auug.org.au>
 <20100707172136.3658fb17.akpm@linux-foundation.org>
 <20100714152042.5b83f03b.akpm@linux-foundation.org>
 <20100715094513.8941fa25.sfr@canb.auug.org.au>
 <20100714172741.f520b7a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714172741.f520b7a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 05:27:41PM -0700, Andrew Morton wrote:
> On Thu, 15 Jul 2010 09:45:13 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew, Al,
> > 
> > On Wed, 14 Jul 2010 15:20:42 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > Bug is still there.  Reverting ""Make ->drop_inode() just return
> > > whether inode needs to be dropped" makes it go away.
> > > 
> > > Al, please don't just dump crap in linux-next and then ignore bug reports. 
> > > People are trying to get work done here.
> > 
> > I will revert that commit in linux-next today if it is still there (and
> > not fixed).
> 
> Reverting the patch didn't help - the patch moved the BUG_ON() from
> generic_delete_inode() into __iput_final().  With the patch reverted
> the kernel still goes BUG over the same test in generic_delete_inode().
> 
> It could be that the bug was caused by fs-writeback.c changes.  David,
> do you have time to take a look at this?

I'll have a look at it. What filesystem(s) are you seeing this on?
Any particular workload that triggers it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
