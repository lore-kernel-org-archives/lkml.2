Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1AJRny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:43:54 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:52461 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1AJRnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:43:53 -0500
Date: Mon, 10 Jan 2011 12:43:29 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Rob <roblinux@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: TSC as clocksource
In-reply-to: <alpine.LFD.2.00.1101101452290.12146@localhost6.localdomain6>
Message-id: <alpine.LFD.2.02.1101101237420.25082@x980>
References: <AANLkTikBu6vggpTUQy_MeTG_PJ9WWoHVyDL0OLPa6v=_@mail.gmail.com>
 <1294667092.11896.0.camel@laptop>
 <alpine.LFD.2.00.1101101452290.12146@localhost6.localdomain6>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Mon, 2011-01-10 at 09:54 +1100, Rob wrote:
> > > Want to use TSC as clocksource
> > > have a Intel Core2 Duo with constant_tsc flag
> > > TSC should be stable at C1 + C2, it is debatable whether C3 is stable

no debate, TSC on Core2 stops in C3.

> > > Using processor.max_cstate=2 to use only C1 + C2 changes nothing, still get
> > > Monitor-Mwait will be used to enter C-3 state
> > > there should be checks before this is forced
> 
> We unconditinally set TSC unstable for anything > C1. The reason is
> that we had a lot of troubles with BIOSes which advertise C2, but in
> fact implement C3. Unfortunately we can't verify that.

Right.
There are some Core2 where what ACPI advertises as C2 the TSC works,
and some where it does something other than "hardware C2",
such as "hardware C3" and the TSC stops, so Linux is conservative here.

If you want a stable TSC on Core2 (and before)
then you need to use either idle=poll or processor.max_cstate=1.

Nehalem and newer (Core i7 etc) have an invarient TSC that works no matter
what C-states are present.

cheers,
Len Brown, Intel Open Source Technology Center
