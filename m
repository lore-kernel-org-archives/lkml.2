Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0IJIhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:37:55 -0400
Received: from www.tglx.de ([62.245.132.106]:45030 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0IJIhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:37:53 -0400
Date: Fri, 10 Sep 2010 10:37:31 +0200 (CEST)
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
In-Reply-To: <87eid282pj.fsf@spindle.srvr.nix>
Message-ID: <alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>
References: <87eid282pj.fsf@spindle.srvr.nix>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010, Nix wrote:

> On 10 Sep 2010, Artur Skawina spake thusly:
> > I'm seeing this too, except here it happens every couple of days of uptime,
> > lasts for a few minutes, and then goes away. Which made bisecting a bit
> > impractical... Thank you for doing it. 
> 
> I just happened to be the lucky sod for whom it was consistently going
> wrong. :)
> 
> > HW is similar; x64 and X58/82801JI/ICH10, tsc clocksrc.
> > Did that printk trigger?
> 
> No.
> 
> (hm, odd.
> 
> spindle:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> 
> spindle:~# grep -i tsc /proc/timer_list
> spindle:~# grep -i hpet /proc/timer_list
> Clock Event Device: hpet
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
> 
> I suspect current_clocksource doesn't do what we think it does, or the
> clocksource and 'clock event device' are not the same.)

Right, they are not the same. clocksource provides us a read out
device for timekeeping (usually a simple increasing counter). clock
event device is used to generate timer interrupts.

HPET provides both functionalities.

The patch you bisected is affecting the clock events part of the
HPET. So yes, it's not a clock source problem.

I'm a bit at a loss here. We need information from Intel.

@hpa, suresh - can you please have a look at this ?

Thanks,

	tglx
