Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2DJC1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:27:00 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52266 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab2DJC07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:26:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYLAEOag095LElM/2dsb2JhbABEuEcBgQmBCIIJAQEFJxMcIxAIAw4KLhQlAyETiA26YxOLGoFcg1gElWuQN4J5gUQG
Date: Tue, 10 Apr 2012 12:26:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jan Kara <jack@suse.cz>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.32->3.0
Message-ID: <20120410022628.GN18323@dastard>
References: <4F75E46E.2000503@msgid.tls.msk.ru>
 <20120405232913.GA6640@quack.suse.cz>
 <4F7E74F4.90604@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7E74F4.90604@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 08:45:40AM +0400, Michael Tokarev wrote:
> On 06.04.2012 03:29, Jan Kara wrote:
> 
> > On Fri 30-03-12 20:50:54, Michael Tokarev wrote:
> >> I'm observing a dramatic slowdown of several hosts after upgrading
> >> from 2.6.32.y to 3.0.x i686 kernels (in both cases from kernel.org,
> >> on both cases the last version is relatively latest).
> []
> >> What's the way to debug this issue?
> >   Identifying a particular kernel where things regresses might help as Jon
> > wrote. Just from top of my head, 3.0 had a bug in device plugging so
> > readahead was broken. I think it was addressed in -stable series so you
> 
> That's definitely not readahead, it since writes are painfully slow
> too.  I found one more example -- extlinux --once="test kernel" with
> 3.0 takes about 20 seconds to complete on an idle system.
> 
> > might want to check out latest 3.0-stable.
> 
> I did mention this in my initial email (that part quoted above) --
> both 2.6.32 and 3.0 are relatively latest from each series,
> right now it is 3.0.27.
> 
> Yesterday I tried to do some bisection, but ended up in an unbootable
> system (it is remote production server), so now I'm waiting for remote
> hands to repair it (I don't yet know what went wrong, we'll figure it
> out).  I've some time during nights when I can do anything with that
> machine, but I have to keep it reachable/working on each reboot.
> 
> Apparently I was wrong saying that there's another machine which
> suffers from the same issue -- nope, the other machine had an unrelated
> issue which I fixed.  So it turns out that from about 200 different
> machines, I've just one machine which does not run 3.0 kernel properly.
> I especially tried 3.0 on a few more - different - machines last
> weekend, in order to see what other machines has this problem, but
> found nothing.
> 
> So I'll try to continue (or actually _start_) the bisection on this
> very server, the way it will be possible having in mind the difficult
> conditions.
> 
> I just thoght I'd ask first, maybe someone knows offhand what may be
> the problem.. ;)

Barriers. Turn them off, and see if that fixes your problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
