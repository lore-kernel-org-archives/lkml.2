Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0HBLCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:02:46 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12942 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab0HBLCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:02:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJxBVkx5Ld2l/2dsb2JhbACgDHK+ZYU5BA
Date: Mon, 2 Aug 2010 20:07:29 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802100729.GB9427@amd>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
 <20100802055834.GB19164@dastard>
 <20100802075537.GC7841@amd>
 <20100802082428.GA23135@infradead.org>
 <20100802090542.GA32322@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802090542.GA32322@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 05:05:42AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 02, 2010 at 04:24:28AM -0400, Christoph Hellwig wrote:
> > .36.  I'd much rather see the inode_lock scaling or the lockless path
> > walk going in before, but I haven't checked how complicated the
> > reordering would be.  The lockless path walk also is only rather
> > theoretically useful until we do ACL checks lockless as we're having
> > ACLs enabled pretty much everywhere at least in the distros.
> 
> >From a quick look it seems like the inode_lock splitup can easily
> be moved forward, and it would help us with doing some work on the
> writeback side.  The problem is that it would need rebasing ontop
> of both the vfs and writeback (aka block) trees.

inode_lock splitup is much simpler than dcache_lock, yes.

And I have to rebase it on the work currently queued for 2.6.35
anyway, so that's no problem. I can easily put it in front of
dcache_lock patches in the series (as I said, I've kept everything
independent and well split up).

I do want opinions on how to do the big-picture merge, though,
before I start moving things around. And obviously reviewing
each of the parts is more important at this point than exact
way to order the thing.

But even the inode_lock patches I am wary of merging in 2.6.36
without having much review or any linux-next / vfs-tree exposure.

