Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0INWSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:18:32 -0400
Received: from www.tglx.de ([62.245.132.106]:38682 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0INWSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:18:31 -0400
Date: Wed, 15 Sep 2010 00:18:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nix <nix@esperi.org.uk>
cc: Artur Skawina <art.08.09@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
In-Reply-To: <878w34qdu0.fsf@spindle.srvr.nix>
Message-ID: <alpine.LFD.2.00.1009150015500.2416@localhost6.localdomain6>
References: <87eid282pj.fsf@spindle.srvr.nix> <alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6> <alpine.LFD.2.00.1009141207310.2416@localhost6.localdomain6> <878w34qdu0.fsf@spindle.srvr.nix>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Nix wrote:

> On 14 Sep 2010, Thomas Gleixner said:
> 
> > On Fri, 10 Sep 2010, Thomas Gleixner wrote:
> >> On Fri, 10 Sep 2010, Nix wrote:
> >> > 
> >> > I suspect current_clocksource doesn't do what we think it does, or the
> >> > clocksource and 'clock event device' are not the same.)
> >> 
> >> Right, they are not the same. clocksource provides us a read out
> >> device for timekeeping (usually a simple increasing counter). clock
> >> event device is used to generate timer interrupts.
> >> 
> >> HPET provides both functionalities.
> >> 
> >> The patch you bisected is affecting the clock events part of the
> >> HPET. So yes, it's not a clock source problem.
> >
> > Another question. If you add hpet=verbose (or revert that commit) does
> > the printk_once in hpet_set_next_event() show up in dmesg ?
> >
> >     "hpet: compare register read back failed."
> 
> Well, given that I reverted that commit in the past (during the
> bisection) and also added hpet=verbose[1], I'd have expected it to turn
> up in my past syslogs. There is no sign of it, in syslogs back to 2009.
> 
> 
> [1] and indeed am running 2.6.35.4 with hpet=verbose and no symptoms
>     on the affected system *now* -- a mystery because I thought the
>     hpet=verbose-turns-it-off code was removed, but turning on verbose
>     still seems to quash the bug?! or perhaps it's slightly
>     intermittent and every N boots I'm lucky enough to miss it. I'm
>     slightly chary of rebooting to find out ;}

hpet=verbose forces the read back.

FYI, we got a reasonable explanation now what's going on in hardware
land. Patch is in the works.

Thanks,

	tglx

