Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0HBVyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:54:09 -0400
Received: from www.tglx.de ([62.245.132.106]:58590 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab0HBVyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:54:07 -0400
Date: Mon, 2 Aug 2010 23:51:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <07f0ab73-7a5e-45c3-b2a8-cff745dc6bc7@email.android.com>
Message-ID: <alpine.LFD.2.00.1008022319540.3225@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <4C56E5C7.90206@suse.de>
 <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain> <07f0ab73-7a5e-45c3-b2a8-cff745dc6bc7@email.android.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Mon, 2 Aug 2010, Tejun Heo wrote:

> Hello, Thomas.
> 
> On 08/02/2010 08:52 PM, Thomas Gleixner wrote:
> >> Ooh, another reason is timer locality.  If timers are shared per desc,
> >> they have much higher chance of being on the same processor.  Global
> >> timers would be pretty bad in that respect.
> > 
> > That's irrelevant. If you need to poll an interrupt, then it does not
> > matter at all whether you bounce some cache lines or not.
> > 
> > In fact we have two cases:
> > 
> >    1) An interrupt needs to be polled all the time. That sucks whether
> >       the poll timer bounces a few cache lines or not.
> > 
> >    2) Polling an irq for some time. Either it works again after a
> >       while, so your suckage is restricted to the poll period. If not
> >       see #1
> 
> Hmm... for spurious and watch the above are true and if it were the
> above two it would definitely make more sense to use per-purpose
> global timers.  The problem is w/ expect tho.  It's supposed to be
> used with normal hot paths, so expect/unexpect operations better be
> low overhead and local.  I'll talk more about it in the other reply.

No, it's not. You are just looking at it from the wrong
perspective. The expect scenario is just a different form of
watch. You worked around the problem by moving the timer to 3 seconds
+ slack if everything works as expected, but that's just sloppy. In
fact you really want to kick that thing in when things go awry and
take it away when it comes back to normal.  When things go awry, then
the cache line bouncing is the least of your worries, really.

Thanks,

	tglx

