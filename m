Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0JQCGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:06:36 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31195 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602Ab0JQCGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:06:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAEL1uUx5LcB2gWdsb2JhbAChKRYBARYiIsF4gneCUgQ
Date: Sun, 17 Oct 2010 13:06:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101017020633.GB3162@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004515.GB1614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017004515.GB1614@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:45:15PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 17, 2010 at 04:12:13AM +1100, Nick Piggin wrote:
> > > With the changes Dave implemented based on my suggestions we now have
> > > an abstract locked hash list data type.  It has the normal hash list
> > > operations plus lock/unlock operations.
> > 
> > That's ugly. It just hides the locking. If a bit of casting bothers
> > you then put it in a function where it is used like I did.
> 
> Exposing the implementation details of which bit of a pointer can
> be used as lock when cast to an unsigned long to every user of an
> abstract type is what I would consider ugly, and on similar issues
> I've certainly not been the only one.

The low bit.

 
> > >  So if e.g. the -rt folks need
> > > real locks in there there is one single place they need to touch
> > > instead of every user.  Similarly if we want to add lockdep support
> > > there is just one place to touch.
> > 
> > It's unnecessary.
> 
> What, lockdep support?

Yes. It would be stupid to do lockdep support for bit spinlocks in all
places where they are used. What should be done (and there is work
towards) is to be able to change the bit spinlock API (or add a new one)
so that external lockdep data structure can be given.

