Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0JMXX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:23:29 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:42907 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753717Ab0JMXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:23:28 -0400
Date: Thu, 14 Oct 2010 10:23:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013232319.GZ4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013123008.GA6067@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:30:08PM +1100, Nick Piggin wrote:
> On Wed, Oct 13, 2010 at 07:25:52AM -0400, Christoph Hellwig wrote:
> > On Wed, Oct 13, 2010 at 06:20:58PM +1100, Nick Piggin wrote:
> > > Unfortunate timing that everybody is suddenly interested in the
> > > scalability work :)
> > 
> > People have been interested for a long time.  It's just that we finally
> > made forward progress to get parts of it shape for merging, which should
> > have been done long time ago.
> 
> It has been pretty close, IMO, it just needed some more reviewers, which
> it only just got really.

Going back a couple of weeks, it seemed as far away from inclusion
as when you first posted the series - there had been no substanital
review and nobody wanting to review it in it's current form. Then
I'd heard you were travelling indefinitely.....

There is stuff in the vfs-scale tree that is somewhat controversial
and had not been discussed satisfactorily - the lock ordering
(resulting in trylocks everywhere), the shrinker API change, the
writeback LRU changes, the zone reclaim changes, etc - and some of
them even have alternative proposals for fixing the algorithmic
deficiencies.  Nobody was going to review or accept that as one big
lump.

There's been review now because I went and did what the potential
reviewers were asking for - break the series into smaller, more
easily reviewable and verifiable chunks. As a result, I think we're
close to the end of the review cycle for the inode_lock breakup now.
I think the code is now much cleaner and more maintainable than what I
originally pulled from the vfs-scale tree, and it still provides the
same gains and ability to be converted to RCU algorithms in the
future.

Hence, IMO, the current vfs-scale tree needs to be treated as a
prototype, not as a finished product. It demonstrates the the path
we need to follow to move forward, as well as the gains we will get
as we move in that direction, but the code in that tree is not
guaranteed a free pass into the mainline tree.

> etc. I had to really learn most of the code from scratch to get this far
> and got quite little constructive review really until recently.

Which seems to be another good reason for treating the tree as prototype
code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
