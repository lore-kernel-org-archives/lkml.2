Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1D0AKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:10:12 -0400
Received: from mail.digium.com ([216.207.245.2]:43758 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab1D0AKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:10:10 -0400
Date: Tue, 26 Apr 2011 19:10:06 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Asterisk Developers Mailing List <asterisk-dev@lists.digium.com>
Cc: nikola.ciprich@linuxbox.cz, linux-kernel@vger.kernel.org
Subject: Re: [asterisk-dev] 2.6.32.21 + dahdi_dummy (dahdi-2.3.0.1) -
	uptime related crash?
Message-ID: <20110427001006.GA28543@digium.com>
References: <20110426204016.GA21044@linuxbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426204016.GA21044@linuxbox.linuxbox.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:40:16PM +0200, Nikola Ciprich wrote:
> Hello everybody,
> I have just experienced (almost) simultaneous crash of two identical
> machines running asterisks and using dahdi_dummy. Both machines were running
> without problems for about 250 days and suddenly almost at same time, both
> of them crashed.  both machines were running 2.6.32.21 (SMP x86_64) and
> using dahdi_dummy (dahdi-2.3.0.1)
> 
> here's the tail of the backtrace:
> 
> [<ffffffff81120cc7>] pollwake+0x57/0x60
> [<ffffffff81046720>] ? default_wake_function+0x0/0x10
> [<ffffffff8103683a>] __wake_up_common+0x5a/0x90
> [<ffffffff8103a313>] __wake_up+0x43/0x70
> [<ffffffffa0321573>] process_masterspan+0x643/0x670 [dahdi]
> [<ffffffffa0326595>] coretimer_func+0x135/0x1d0 [dahdi]
> [<ffffffff8105d74d>] run_timer_softirq+0x15d/0x320
> [<ffffffffa0326460>] ? coretimer_func+0x0/0x1d0 [dahdi]
> [<ffffffff8105690c>] __do_softirq+0xcc/0x220
> [<ffffffff8100c40c>] call_softirq+0x1c/0x30
> [<ffffffff8100e3ba>] do_softirq+0x4a/0x80
> [<ffffffff810567c7>] irq_exit+0x87/0x90
> [<ffffffff8100d7b7>] do_IRQ+0x77/0xf0
> [<ffffffff8100bc53>] ret_from_intr+0x0/Oxa
> <EUI> [<ffffffffa019e556>] ? acpi_idle_enter_bm+0x273/0x2a1 [processor]
> [<ffffffffa019e54c>] ? acpi_idle_enter_bm+0x269/0x2a1 [processor]
> [<ffffffff81280095>] ? cpuidle_idle_call+0xa5/0x150
> [<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90
> [<ffffffff81323c95>] ? rest_init+0x75/0x80
> [<ffffffff81582d7f>] ? start_kernel+0x2ef/0x390
> [<ffffffff81582271>] ? x86_64_start_reservations+0x81/0xc0
> [<ffffffff81582386>] ? x86_64_start_kernel+0xd6/0x100
> Sorry, it's trimmed a bit :(
> 
> I can't find any related bugreport, so I'm not sure whether I've hit some
> problem already solved. To me, it seems like some counter might have
> overflowed or the like (that could explain why machines were running for so
> long and then suddenly both of them crashed..)
> Of course used dahdi version was quite old, so I should update anyways, but
> I'd sleep safer if I'd know the problem already got fixed..
> Anyone has some idea?
> Should more information be needed, I'd be more then glad to help...
> Thanks a lot in advance!

Hello Nikola,

Based on what is posted here, I can't think of any reason hwy there
would be a problem in the pollwake function that is timer / overflow
dependent.

I also didn't see any changes in the 2.6.32.y stable repository from
2.6.32.21 to the 2.6.32.28 release that appeared to be in the code path.

The only change that looks like it would even be in the same area is
r9549 [1], which prevents the wait_queues from being reinitialized
before the channel is unregistered, but then I've never personally seen
a case where someone actually hit that, and I can't be certain you did.
Also, that would be a race so the probability of hitting it on two
machines at the same time would be extremely low.

[1] http://svn.asterisk.org/view/dahdi?view=revision&revision=9549

So in summary: I'm not aware of any fixes for what you've seen in either DAHDI
or the 2.6.32 stable kernel. Sorry.

Cheers,
Shaun

-- 
Shaun Ruffell
Digium, Inc. | Linux Kernel Developer
445 Jan Davis Drive NW - Huntsville, AL 35806 - USA
Check us out at: www.digium.com & www.asterisk.org
