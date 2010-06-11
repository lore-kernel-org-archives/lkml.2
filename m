Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526Ab0FKUsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:48:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33234 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753307Ab0FKUsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:48:17 -0400
Date: Fri, 11 Jun 2010 16:48:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: James Bottomley <James.Bottomley@suse.de>
cc: David Brownell <david-b@pacbell.net>, <tytso@mit.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <1276268539.2862.92.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.1006111638040.19894-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010, Mark Brown wrote:

> On Fri, Jun 11, 2010 at 10:46:27AM -0400, Alan Stern wrote:
> > On Fri, 11 Jun 2010, James Bottomley wrote:
> 
> > > The one thing that does look difficult is that these power constraints
> > > are device (and sometimes SoC) specific.  Expressing them in a generic
> > > way for the cpu govenors to make sense of might be hard.
> 
> > Doesn't the clock framework already handle this sort of thing?
> 
> The clock framework is implemented independantly for each CPU.

That's not an impediment, since drivers' requirements regarding which 
clocks remain running in which power states are necessarily 
platform-dependent also.


On Fri, 11 Jun 2010, James Bottomley wrote:

> Well, there are two elements to "this sort of thing":
> 
>      1. Allow a driver to request that a given clock not be turned off.
>      2. Make the cpuidle governors aware of a pending "don't turn off X
>         clock source" so they can keep the system in a state where the
>         clock doesn't get powered down.
> 
> As far as I can tell from the code, neither currently exists at the
> moment.

Well then, can (or should) the clock framework interact with the
pm-qos subsystem so that drivers don't have to worry about it?

Alan Stern

