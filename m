Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1FIC5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:57:49 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4677 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab1FIC5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:57:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowDAK408E15LCoegWdsb2JhbABSpjUVAQEWJiWIcb5yDoYVBKB/
Date: Thu, 9 Jun 2011 12:57:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Theodore Tso <tytso@MIT.EDU>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
Message-ID: <20110609025742.GS32466@dastard>
References: <4DEE1D96.6020208@profihost.ag>
 <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
 <4DEE2C70.8060301@profihost.ag>
 <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
 <4DEE9EDA.90001@profihost.ag>
 <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
 <20110608133037.GF27245@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608133037.GF27245@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:30:37AM -0400, Steven Rostedt wrote:
> On Tue, Jun 07, 2011 at 11:28:59PM -0400, Theodore Tso wrote:
> 
> Ted, you need a new MUA, as it reads horribly in mutt.

Seconded. ;)

> > Not all distributions will participate in the maintenance stable
> > tree.  Red Hat for example is probably worried about people
> > (specifically, Oracle) taking their kernel expertise "for free"
> > and bidding it against them.  So it doesn't surprise me that
> > they aren't submitting patches to the stable tree.  After all,
> > they would like you to purchase a support contract if you want
> > to get high quality, supported kernel.   Why should they give
> > that work away for free?  After all, their salaried developers
> > have to get paid somehow.  Others will contribute work in the
> > hopes that other people will also contribute fixes back, but of
> > course nothing forces Red Hat to do this.
> 
> As a Red Hat employee, I must speak against this. I have *never* been
> told to keep something from stable. In fact, I've always been encouraged
> to push to stable. But it is usually the individual engineer's
> responsibility to get a patch into stable. If something was missed, it
> was more the fault of that individual engineer that made the fix than
> Red Hat.

If you want someone to blame, then point the fingers at me, not
RedHat or RedHat's processes - RedHat is not involved in the
processes and decisions as to what fixes
get backported into the community stable trees. How that is done
is mainly dictated by available resources, which are generally
scarce. We push bug fixes into the lastest kernel release, and if
known to be needed for stable series they get pushed back via the
stable queues.

This particular case is clearly an oversight - when we fixed the
problem I pushed it into the current stable release, but forgot
that we'd also backported fixes to .32 that meant we also needed to
backport this fix to .32 as well.

If you look at a 2.6.32 kernel the fix is not needed for backport,
but somewhere in the 2.6.32.y series, other fixes were backported
which introduce the bug that make this fix necessary. That history
is not in the mainline git tree and so it's really quite easy to
make such a mistake.  So the real cause of this oversight is the
fact that there are simply too many disjoint community trees and
that makes it difficult to determine what fixes need to go where.

As a result of the difficulty tracking stable trees, I don't even
bother trying. Instead I use bug reports as triggers for "we need to
backport this fix" to a stable kernel because I do not have the time
to waste backporting fixes for bugs no-one is actually hitting...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
