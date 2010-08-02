Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HBF6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 01:58:40 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:40920 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579Ab0HBF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 01:58:39 -0400
Date: Mon, 2 Aug 2010 15:58:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802055834.GB19164@dastard>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 07:50:02PM -0700, Linus Torvalds wrote:
> On Sun, Aug 1, 2010 at 7:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > There hasn't been nearly enough review or testing of this patch
> > series yet.  Before a merge, it needs to be split up in smaller,
> > more digestable chunks for more comprehensive review, regression
> > testing and behavioural analysis.
> 
> I dunno. We merge _way_ scarier things in the VM and the block layer,
> for much less actual upside, and with less review.

Scary stuff outside of direct VFS/FS interfaces is generally hidden
from me by my +6 Blinkers of Blissful Ignorance. I make the
assumption that the experts involved know the risks and have weighed
them up appropriately. ;)

> The RCU pathname lookup has some rather impressive performance
> upsides, and I agree that it would be good to get a lot of review and
> testing, but the latter isn't going to happen without it being
> mainlined, and the former is sadly lacking. The person I'd like most
> to review it is Al,

Most definitely.

> but anybody in the filesystem world should
> basically see it as a #1 priority,

Agreed - I've actually looked at every patch, commented on some
of the more questionable things, got quoted by LWN for saying that
it "fell off the locking cliff", have run benchmarks on it and sent
patches fixing bugs back to Nick.

It's just really hard to digest it all in one lump and core VFS
changes on this scale scare me....

> because unlike all the masturbatory
> patches like xstat() that add new functionality that nobody will
> likely ever use, Nick's patchseries improves on the thing that
> everybody uses heavily every day without even thinking about it.
> 
> Is it tough to review? Yes. It's core code, not just some random
> addition that adds a new feature and doesn't impact any old code. But
> that's also the thing that makes it meaningful, and makes me think it
> should get merged _much_ more eagerly than most code we ever see.

I agree with you for the pure locking changes.

But for the bits that change writeback, LRU ordering and reclaim
calculations the benefits are not quite so obvious, nor is the
correctness of the code/behaviour quite so provably correct.  Maybe
I'm being a bit too paranoid, but generally it pays to be a bit
conservative as a filesystem developer because the cost of screwing
up can be pretty high...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
