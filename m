Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0GADeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 23:34:03 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:56542 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251Ab0GADeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 23:34:00 -0400
Date: Thu, 1 Jul 2010 13:33:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 52/52] fs: icache less I_FREEING time
Message-ID: <20100701033342.GT24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030734.042332166@suse.de>
 <20100630101354.GK24712@dastard>
 <20100630121452.GG21358@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630121452.GG21358@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 10:14:52PM +1000, Nick Piggin wrote:
> On Wed, Jun 30, 2010 at 08:13:54PM +1000, Dave Chinner wrote:
> > On Thu, Jun 24, 2010 at 01:03:04PM +1000, npiggin@suse.de wrote:
> > > Problem with inode reclaim is that it puts inodes into I_FREEING state
> > > and then continues to gather more, during which it may iput,
> > > invalidate_mapping_pages, be preempted, etc. Holding these inodes in
> > > I_FREEING can cause pauses.
> > 
> > What sort of pauses? I can't see how holding a few inodes in
> > I_FREEING state would cause any serious sort of holdoff...
> 
> Well if the inode is accessed again, it has to wait for potentially
> hundreds of inodes to be found from the LRU, pagecache invalidated,
> and destroyed.

So it's a theoretical concern you have, not something that's
actually been demonstrated as a problem?

As it is, If the inode is accessed immediately after teardown has
started, then we failed to hold on to the inode at a higher level
for long enough. Changing the I_FREEING behaviour is trying to
address the issue at the wrong level...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
