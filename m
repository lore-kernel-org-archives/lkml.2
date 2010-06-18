Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0FRGZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:25:11 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:58280 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0FRGZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:25:07 -0400
Date: Fri, 18 Jun 2010 02:25:01 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Mike Chan <mike@android.com>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: RFC: /sys/power/policy_preference
In-reply-to: <AANLkTilkblF0tfSnvLdVZVOi0r-dc32uAMuaiUlKesdn@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1006180156460.7628@localhost.localdomain>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
 <AANLkTilkblF0tfSnvLdVZVOi0r-dc32uAMuaiUlKesdn@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Mike Chan wrote:

> On Wed, Jun 16, 2010 at 2:05 PM, Len Brown <lenb@kernel.org> wrote:
> > Create /sys/power/policy_preference, giving user-space
> > the ability to express its preference for kernel based
> > power vs. performance decisions in a single place.
> >
> > This gives kernel sub-systems and drivers a central place
> > to discover this system-wide policy preference.
> > It also allows user-space to not have to be updated
> > every time a sub-system or driver adds a new power/perf knob.
> >
> 
> This might be ok as a convince feature for userspace, but if that is
> the sole intention, is 5 states enough?
>
> Are these values sufficient? I
> can say at least for Android this will probably won't be as useful
> (but perhaps on your platforms it makes sense).

Honestly, my first thought was to use 100 values -- a percentage.
But I got quickly taked out of it by people much wiser than me.

Consider that the vendors that are cleaning Linux's clock
on laptops seem quite content with 3 values at the user-interface.
So one might argue that 5 levels is already 66% more complexity
than needed:-)

Some suggested special case states, eg for HPC.
But those needs didn't fit into this simple power vs performance
continuum, and every consumer of this interface needs to undertand
every state, so adding special states would be a mistake.

The folks that do HPC and the folks that do embedded devices
are smart enough to tune their systems without using this
rather blunt instrument.  They should continue to do so,
and this mechanism should not get in their way.

For example, if this mechanism is used to update powersave_bias
inside ondemand, but at the same time somebody tunes powersave_bias
by hand, the by-hand tuning must win.

> As for a place for subsystems and drivers to check for what
> performance mode you're in, do my driver how to check two places now?
> Whats stopping someone from overriding cpufreq, or cpuidle? I might be
> confused here (if I am someone please correct me) but isn't this
> somewhat along he lines of pm runtime / pm qos if drivers want to
> check what power / performance state the system is in?

pm runtime and pm qos are much bigger hammers, and this
mechanism is intended to complement them, not replace them.

Simply stated, this mechanism is intended just to give
a global hint of the user's power vs. performance preference
at a given time.  There are places in the kernel and drivers
where power vs performance decisions are made with zero
concept of user preference, and this hint can help there.

Other parts of the kernel don't care, or have sufficient
information to make informed decisions, and thus they
simply wouldn't need to make use of this hint.

thanks,
Len Brown, Intel Open Source Technology Center

