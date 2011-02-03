Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1BCAIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:08:06 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2191 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598Ab1BCAID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:08:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM5+SU15LGFf/2dsb2JhbAClInS7aA2FRgQ
Date: Thu, 3 Feb 2011 11:07:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Alex Elder <aelder@sgi.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.38-rc3
Message-ID: <20110203000757.GT11040@dastard>
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
 <4D482E21.5040803@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D482E21.5040803@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:00:33AM -0500, Mark Lord wrote:
> On 11-01-31 11:42 AM, Alex Elder wrote:
> > Linus, please accept the following updates for XFS, for 2.6.38-rc3
> > (if it's not too late) or 2.6.38-rc4.
> > 
> > They are all fixes for bugs that have some pretty undesirable
> > consequences.  They address:
> > - One spot in which a hang can occur due to neglecting to drop a
> >   lock
> > - A bug which in some cases a bogus block number can be recorded in
> >   a block map btree, resulting in a subsequent BUG_ON().
> > - Two memory leaks
> > - Three places in which extent sizes are allowed to exceed various
> >   size limits
> > - One place where code depends on behavior that is not well-defined
> >   by the C standard
> > - One problem in handling transaction commit errors
> 
> 
> Are these bugs all new in 2.6.38, or should some of these fixes
> also go out to -stable for earlier revisions?
> 
> 
> > Dave Chinner (8):
> >       xfs: fix log ticket leak on forced shutdown.
> >       xfs: fix efi item leak on forced shutdown

Been there for years, extremely hard to hit, so no.

> >       xfs: speculative delayed allocation uses rounddown_power_of_2 badly

-38-rc1 regression, so no.

> >       xfs: limit extent length for allocation to AG size
> >       xfs: prevent extsize alignment from exceeding maximum extent size
> >       xfs: limit extsize to size of AGs and/or MAXEXTLEN

Been there for years in little used functionality, so no.

> >       xfs: handle CIl transaction commit failures correctly

Introduced with new code in 2.6.35, hard to hit, only results in
small memory leaks, so no.

> >       xfs: fix dquot shaker deadlock

That's a regression, so maybe.

> > bpm@sgi.com (1):
> >       xfs: xfs_bmap_add_extent_delay_real should init br_startblock

Been there for years, no evidence ATM that this code path can be
exercised with a mainline kernel, so no.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
