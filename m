Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0FNWZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:25:05 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:41301 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756917Ab0FNWZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:25:03 -0400
Date: Tue, 15 Jun 2010 08:24:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
 statement warnings
Message-ID: <20100614222458.GF6590@dastard>
References: <20100610110.764742110@firstfloor.org>
 <20100610111052.3DDC5B1A2B@basil.firstfloor.org>
 <20100614042700.GC6590@dastard>
 <20100614074309.GA17092@basil.fritz.box>
 <20100614133755.GE6590@dastard>
 <20100614143720.GI17092@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614143720.GI17092@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 04:37:20PM +0200, Andi Kleen wrote:
> > > > function head comment during development.  Anyway, if we do get an
> > > > error here, we cannot handle it anyway - it's too late to do
> > > > anything short of a complete shutdown as we've already written the
> > > > transaction to the log.
> > > 
> > > Well I guess it should be unconditional BUG_ON then.
> > 
> > Don't be silly. A filesystem shutdown is all that is necessary,
> 
> Without BUG_ON it will not end up in kerneloops.org and you will
> never know about it. 

We find out about corrupted filesystems all the time from users
sending mail to the list. Even if we did panic by default on
corruption events, kerneloops.org is *useless* for reporting them
because finding out about a corruption is only the very first step
of what is usually a long and involved process that requires user
interaction to gather information necessary to find the cause of the
corruption.

Besides, if we _really_ want the machine to panic on corruption,
then we configure the machine specifically for it via setting the
relevant corruption type bit in /proc/sys/fs/xfs/panic_mask. This is
generally only used when a developer asks a user to set it to get
kernel crash dumps triggered when a corruption event occurs so we
can do remote, offline analysis of the failure.

> That's standard Linux kernel development
> practice.  Maybe XFS should catch up on that.

I find this really amusing because linux filesystems have, over the
last few years, implemented a simpler version of XFS's way of
dealing with corruption events(*). Perhaps you should catch up
with the state of the art before throwing rocks, Andi....

Cheers,

Dave.

(*) extN, fat, hpfs, jfs, nilfs2, ntfs, ocfs2 and logfs all have
configurable corruption event behaviour that default to remount-ro
and can be configured to panic the machine.
-- 
Dave Chinner
david@fromorbit.com
