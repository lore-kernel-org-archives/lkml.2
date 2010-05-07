Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab0EGQKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:10:42 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62030 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab0EGQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:10:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Yr7/1H3CiT3pNz3QWQhEr
Date: Fri, 7 May 2010 09:10:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: James Kosin <james.kosin.04@cnu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507161032.GD387@atomide.com>
References: <eGToe-3b9-5@gated-at.bofh.it>
 <eGUaB-4mU-1@gated-at.bofh.it>
 <eGUtX-4Kd-3@gated-at.bofh.it>
 <eGWvL-7Fy-1@gated-at.bofh.it>
 <eGWFt-7S7-17@gated-at.bofh.it>
 <eGWP9-8jH-17@gated-at.bofh.it>
 <4BE37DDD.8000402@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE37DDD.8000402@cox.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* James Kosin <james.kosin.04@cnu.edu> [100506 19:38]:
> On 5/5/2010 8:10 PM, Tony Lindgren wrote:
> > * Brian Swetland <swetland@google.com> [100505 16:51]:
> >> On Wed, May 5, 2010 at 4:47 PM, Tony Lindgren <tony@atomide.com> wrote:
> >>> * Brian Swetland <swetland@google.com> [100505 14:34]:
> >>>> On Wed, May 5, 2010 at 2:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> <<-- snip -->>
> >>>>> At no point does the user program have to communicate anything to the
> >>>>> modem driver, and at no point does it have to do anything out of the
> >>>>> ordinary except to enable and disable a suspend blocker.
> >>>>
> >>>> Exactly -- and you can use the same style of overlapping suspend
> >>>> blockers with other drivers than input, if the input interface is not
> >>>> suitable for the particular interaction.
> >>>
> >>> Would the suspend blockers still be needed somewhere in the example
> >>> above?
> >>
> >> How often would we retry suspending?
> > 
> > Well based on some timer, the same way the screen blanks? Or five
> > seconds of no audio play? So if the suspend fails, then reset whatever
> > userspace suspend policy timers.
> >  
> 
> Tony,
> Wouldn't this be handled by the idle task, or task manager?

My thinking is that suspend should be only triggered from the
userspace based on a device specic policy. Suspend breaks
standard Linux behaviour as all the timers will stop running.

You can already implement suspend-like idle states for various
processors that are controlled by cpuidle.

In those cases the device hits suspend or off modes in the kernel
idle loop. In this case the system keeps running waking every
few seconds or so when idle, and the timers behave the normal way.

Of course there can be tens or even few hundred millisecond
wake-up latencies in the case of hitting off and restoring the
kernel during idle, so interrupt response time in those cases
is longer.

> When all tasks are suspended and not doing anything that should be the
> first clue that a real suspend cycle could be attempted.

Yeah, but I don't think there's a generic way of figuring
out when it's OK to suspend. It depends on the device. It
can also depend on how the user wants to configure things.

Regards,

Tony
