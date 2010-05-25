Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab0EYBe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:34:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49468 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754449Ab0EYBez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:34:55 -0400
Date: Mon, 24 May 2010 21:34:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: <AANLkTikz2UcDv6BZQ9Hq2MdowuAK1y_PBBPPXMEkDmNa@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005242130290.8440-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010, Arve Hjønnevåg wrote:

> > Wakeup events can be lost in at least three different ways:
> >
> >     1. A hardware signal (such as an IRQ) gets ignored.
> >
> >     2. The hardware event occurs, but without effect since the
> >        kernel thread that would handle the event has been frozen.
> >        The event just ends up sitting in a queue somewhere until
> >        something else wakes up the system.
> >
> >     3. The hardware event occurs and the kernel handles it fully,
> >        but the event propagates to userspace for further handling
> >        and the user program is already frozen.
> >
> > 1 is a hardware configuration failure (for example, it might happen as
> > a result of using edge-triggered IRQs instead of level-triggered) and
> > is outside the scope of this discussion.
> >
> > 2 generally represents a failure of the core PM subsystem, or a failure
> > of some other part of the kernel to use the PM core correctly.  In
> > theory we should be able to fix such mistakes.  Right now I'm aware of
> > at least one possible failure scenario that could be fixed fairly
> > easily.
> >
> > 3 is the type of failure that suspend blockers were really meant to
> > handle, particularly the userspace suspend-blocker API.

> I don't see a big difference between 2 and 3. You can use suspend
> blockers to handle either.

You can, but they aren't necessary.  If 2 were the only reason for 
suspend blockers, I would say they shouldn't be merged.

Whereas 3, on the other hand, can _not_ be handled by any existing
mechanism.  3 is perhaps the most important reason for using suspend
blockers.

Alan Stern

