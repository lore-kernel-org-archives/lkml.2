Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1D0K2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:28:30 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16978 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab1D0K23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:28:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAHvtt015LHHJgWdsb2JhbAClahUBARYmJYhwuXwOhWgEnQ8
Date: Wed, 27 Apr 2011 20:28:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110427102824.GI12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
 <20110424234655.GC12436@dastard>
 <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
 <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 12:46:51AM -0700, Christian Kujau wrote:
> On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
> > What this shows is that VFS inode cache memory usage increases until
> > about the 550 sample mark before the VM starts to reclaim it with
> > extreme prejudice. At that point, I'd expect the XFS inode cache to
> > then shrink, and it doesn't. I've got no idea why the either the
> 
> Do you remember any XFS changes past 2.6.38 that could be related to 
> something like this?

There's plenty of changes that coul dbe the cause - we've changed
the inode reclaim to run in the background out of a workqueue as
well as via the shrinker, so it could even be workqueue starvation
causing the the problem...

hmmmm. Speaking of which - have you changed any of the XFS tunables
in /proc/sys/fs/xfs/ on your machine (specifically
xfssyncd_centisecs)?

> Bisecting is pretty slow on this machine. Could I somehow try to run 
> 2.6.39-rc4 but w/o the XFS changes merged after 2.6.38? (Does someone know 
> how to do this via git?)

Not easy because there are tree-wide changes that need to be
preserved (e.g. block layer plugging changes) while others around it
would need to be reverted....

> > Can you check if there are any blocked tasks nearing OOM (i.e. "echo
> > w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
> > stuck somewhere?
> 
> Will do, tomorrow.
> 
> Should I open a regression bug, so we don't loose track of this thing?

Whatever you want. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
