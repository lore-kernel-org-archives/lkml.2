Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320Ab1D0X5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:57:05 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7489 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757Ab1D0X5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:57:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIEAGSruE15LHHJgWdsb2JhbAClfhUBARYmJcRiDoVoBJ0P
Date: Thu, 28 Apr 2011 09:56:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110427235658.GJ12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
 <20110424234655.GC12436@dastard>
 <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
 <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
 <20110427102824.GI12436@dastard>
 <BANLkTimDoZueDWqB_LBndqPorCnTOZkNYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimDoZueDWqB_LBndqPorCnTOZkNYQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 08:16:29AM +0900, Minchan Kim wrote:
> On Wed, Apr 27, 2011 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Apr 27, 2011 at 12:46:51AM -0700, Christian Kujau wrote:
> >> On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
> >> > What this shows is that VFS inode cache memory usage increases until
> >> > about the 550 sample mark before the VM starts to reclaim it with
> >> > extreme prejudice. At that point, I'd expect the XFS inode cache to
> >> > then shrink, and it doesn't. I've got no idea why the either the
> >>
> >> Do you remember any XFS changes past 2.6.38 that could be related to
> >> something like this?
> >
> > There's plenty of changes that coul dbe the cause - we've changed
> > the inode reclaim to run in the background out of a workqueue as
> > well as via the shrinker, so it could even be workqueue starvation
> > causing the the problem...
> 
> RCU free starvation is another possibility?
> https://lkml.org/lkml/2011/4/25/124

You know, I've been waching that thread with interest, but it didn't
seem to be related. However, now that I go look at the config file
provided, I see:

CONFIG_TINY_RCU=y
# CONFIG_SMP is not set
CONFIG_PREEMPT_NONE=y

which means it probably is the same rcu free starvation problem as
reported in that thread.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
