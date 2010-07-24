Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0GXAVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 20:21:20 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:46955 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708Ab0GXAVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 20:21:18 -0400
Date: Sat, 24 Jul 2010 10:21:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Frank Mayhar <fmayhar@google.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: VFS scalability git tree
Message-ID: <20100724002101.GL32635@dastard>
References: <20100722190100.GA22269@amd>
 <20100723111310.GI32635@dastard>
 <20100723155118.GB5773@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723155118.GB5773@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 01:51:18AM +1000, Nick Piggin wrote:
> On Fri, Jul 23, 2010 at 09:13:10PM +1000, Dave Chinner wrote:
> > On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> > > I'm pleased to announce I have a git tree up of my vfs scalability work.
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> > > http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git
> > > 
> > > Branch vfs-scale-working
> > 
> > I've got a couple of patches needed to build XFS - they shrinker
> > merge left some bad fragments - I'll post them in a minute. This
> 
> OK cool.
> 
> 
> > email is for the longest ever lockdep warning I've seen that
> > occurred on boot.
> 
> Ah thanks. OK that was one of my attempts to keep sockets out of
> hidding the vfs as much as possible (lazy inode number evaluation).
> Not a big problem, but I'll drop the patch for now.
> 
> I have just got one for you too, btw :) (on vanilla kernel but it is
> messing up my lockdep stress testing on xfs). Real or false?
> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.35-rc5-00064-ga9f7f2e #334
> -------------------------------------------------------
> kswapd0/605 is trying to acquire lock:
>  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffff8125500c>]
> xfs_ilock+0x7c/0xa0
> 
> but task is already holding lock:
>  (&xfs_mount_list_lock){++++.-}, at: [<ffffffff81281a76>]
> xfs_reclaim_inode_shrink+0xc6/0x140

False positive, but the xfs_mount_list_lock is gone in 2.6.35-rc6 -
the shrinker context change has fixed that - so you can ignore it
anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
