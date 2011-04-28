Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab1D1XiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:38:07 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:10573 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755445Ab1D1XiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:38:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmUDAFr5uU15LHHJgWdsb2JhbACmABUBARYmJcZdDoVoBJx5
Date: Fri, 29 Apr 2011 09:37:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110428233751.GR12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
 <20110424234655.GC12436@dastard>
 <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
 <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
 <20110427102824.GI12436@dastard>
 <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:30:47AM -0700, Christian Kujau wrote:
> Hi David,
> 
> sorry for the late response:
> 
> On Wed, 27 Apr 2011 at 20:28, Dave Chinner wrote:
> > hmmmm. Speaking of which - have you changed any of the XFS tunables
> > in /proc/sys/fs/xfs/ on your machine (specifically
> > xfssyncd_centisecs)?
> 
> No, I did not change anything underneath /proc/sys/fs/xfs.
>  
> > Not easy because there are tree-wide changes that need to be
> > preserved (e.g. block layer plugging changes) while others around it
> > would need to be reverted....
> 
> Yeah, I noticed. I wanted to do something like this:
> 
>   $ for c in `git log --pretty=oneline --no-merges v2.6.38..v2.6.39-rc2 fs/xfs | awk '{print $1}'`; do
>        git revert $c
>     done
> 
> ...but this broke on the 1st or 2nd commit because of unresolved changes.
> 
> Now I'm in the middle of another bisect attempt, trying to reproduce but 
> Im getting (probably totally unrelated) warnings here:

Did you read the email that pointed to CONFIG_TINY_RCU as the
ptotential source of the problem? Can you change to CONFIG_TREE_RCU
and see if the problem goes away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
