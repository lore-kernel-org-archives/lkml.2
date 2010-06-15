Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0FOHCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:02:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40671 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0FOHCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:02:47 -0400
Date: Tue, 15 Jun 2010 09:02:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100615070244.GD6727@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111052.3DDC5B1A2B@basil.firstfloor.org> <20100614042700.GC6590@dastard> <20100614074309.GA17092@basil.fritz.box> <20100614133755.GE6590@dastard> <20100614143720.GI17092@basil.fritz.box> <20100614222458.GF6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614222458.GF6590@dastard>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We find out about corrupted filesystems all the time from users
> sending mail to the list. Even if we did panic by default on
> corruption events, kerneloops.org is *useless* for reporting them
> because finding out about a corruption is only the very first step
> of what is usually a long and involved process that requires user
> interaction to gather information necessary to find the cause of the
> corruption.

The idea behind kerneloops.org 
is normally that any single report can be always a flake
(broken memory, hardware, flipped bit whatever).

An error becomes important and interesting when there are multiple
occurrences of it in the field.
> 
> Besides, if we _really_ want the machine to panic on corruption,

BUG_ON is not panic normally.

> then we configure the machine specifically for it via setting the
> relevant corruption type bit in /proc/sys/fs/xfs/panic_mask. This is
> generally only used when a developer asks a user to set it to get
> kernel crash dumps triggered when a corruption event occurs so we
> can do remote, offline analysis of the failure.

Especially when you're talking about desktop class systems
without ECC memory that will mean you'll spend at least some
time on errors which are simply bit flips.

> > That's standard Linux kernel development
> > practice.  Maybe XFS should catch up on that.
> 
> I find this really amusing because linux filesystems have, over the

This has really nothing to do with file systems, it's general
practice for everything (well except XFS) 

> last few years, implemented a simpler version of XFS's way of
> dealing with corruption events(*). Perhaps you should catch up
> with the state of the art before throwing rocks, Andi....

I suspect you miss quite a lot of valuable information from
your user base by not supporting kerneloops.org. On the other
hand it would likely also save you from spending time on 
flakes.

That said you don't need BUG_ON to support it (WARN etc. work
too), it's just the easiest way.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
