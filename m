Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2C1JHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:07:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab2C1JHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:07:08 -0400
Date: Wed, 28 Mar 2012 11:07:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 11/13] Add a discussion on why spin_is_locked() is bad to spinlocks.txt
Message-ID: <20120328090707.GW22197@one.firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org> <1332895637-32572-12-git-send-email-andi@firstfloor.org> <20120328084824.GA2522@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328084824.GA2522@pengutronix.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +or some variant of those.
> > +
> > +This does not work on uniprocessor kernels because they will always fail.
> > +While there are ways around that they are ugly and not recommended.
> > +Better use lockdep_assert_held(). This also only checks on a lock debugging
> > +kernel (which you should occasionally run on your code anyways because
> > +it catches many more problems). 
> > +
> > +In generally this would be better done with static annotation anyways 
> > +(there's some support for it in sparse)
> > +
> > +	BUG_ON(spin_is_locked(obj->lock));
> > +	kfree(obj);
> > +
> > +Another usage is checking whether a lock is not hold when freeing an object.
> 
> I'd suggest to move this sentence above the code example. On first read,
> I was confused what the code should tell me regarding annotations :)

Both fixed.

> 
> > +However this is redundant because lock debugging supports this anyways
> > +without explicit code. Just delete the BUG_ON.
> > +
> > +A third usage is to check in a console function if a lock is hold, to get
> > +a panic crash dump out even when some other thread died in it.
> > +This is better implemented with spin_try_lock() et.al. and a timeout.
> > +
> > +Other usages are usually simply races.
> > +
> > +In summary just don't use it.
> 
> At this point, I was wondering when it actually can be used? Otherwise
> it probably would have been removed from the kernel or marked
> deprecated, I'd think?

Even after the patchkit there are a few users left (mostly third category
and some print outs). Eventually these should be fixed or removed too.
Then the function could be truly deprected.

lockdep still needs it I believe, but it should probably use some 
private interface. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
