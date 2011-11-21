Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1KUA6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 19:58:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:38362 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1KUA6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 19:58:39 -0500
Message-ID: <1321837101.13860.6.camel@pasglop>
Subject: Re: 3.2.0-rc1 panic on PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Date: Mon, 21 Nov 2011 11:58:21 +1100
In-Reply-To: <alpine.DEB.2.01.1111201529070.8000@trent.utfs.org>
References: <alpine.DEB.2.01.1111150035560.8000@trent.utfs.org>
	 <alpine.DEB.2.01.1111201529070.8000@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-20 at 15:31 -0800, Christian Kujau wrote:
> On Tue, 15 Nov 2011 at 00:44, Christian Kujau wrote:
> > I noticed a few crashes on this PowerBook G4 lately, starting somewhere in 
> > 3.2.0-rc1. The crashes are really rare and as I'm not on the system all 
> > the time I did not notice most of them. By the time I did, the screen was 
> > blank already and I had to hard-reset the box. But not this time:
> > 
> >   http://nerdbynature.de/bits/3.2.0-rc1/oops/
> > 
> > When the crash occured, the system was failry loaded (CPU and disk I/O 
> > wise), so that may have triggered it. I tried to type off the stack trace, 
> > I hope there are not too many typos, see below.
> > 
> > The machine is fairly old, so maybe it's "just" bad RAM or something, I 
> > wouldn't be suprised. But maybe not, the box us pretty stable most of the 
> > time and only now I notice these rare crashes.
> 
> Happened again with 3.2.0-rc2-00027-gff0ff78, this time with netconsole 
> enabled. But this time the machine just stopped, w/o any output on the 
> screen or on netconsole :(

I've seen something similar with 3.2-rc2 at cfcfc9ec, unfortunately I
couldn't capture the oops log at the time.

Looks like there's some kind of memory corruption happening. So far I
haven't been able to get a good target at what could be causing it.

Cheers,
Ben.

> Christian.
> 
> > If anyone could take a quick look...?
> > 
> > Thank you,
> > Christian.
> > 
> > Instruction dump:
> > 92c40008 68000001 0f000000 80040000 5400003c 90040000 817f000c 380bffff
> > 901f000c 2f090000 81640018 81440014 <916a0004> 914b0000 92840014 92a49918
> > Kernel panic - not syncing: Fatal exception in interrupt
> > Call Trace:
> > show_stack+0x70/0x1bc (unreliable)
> > panic+0xc8/0x220
> > die+0x2ac/0x2b8
> > bad_page_fault+0xbc/0x104
> > handle_page_fault+0x7c/0x80
> > Exception: 300 at T.975+0x3f4/0x570
> > LR = T.957+0x300/0x570
> > kmem_cache_alloc+0x150/0x150
> > __aloc_skb+0x50/0x148
> > tcp_send_ack+0x35/0x138
> > tcp_delay_timer+0x140/0x244
> > run_timer_softirq+0x1a0/0x2ec
> > __do_softirq+0xf4/0x1bc
> > call_do_softirq+0x14/0x24
> > do_softirq+0xfc/0x128
> > irq_exit+0xa0/0xa4
> > timer_interrupt+0x148/0x180
> > ret_from_except+0x0/0x14
> > cpu_idle+0xa0/0x118
> > rest_init+0xf0/0x114
> > start_kernel+0x2d0/0x2f0
> > 0x3444
> > Rebooting in 180 seconds..
> > 
> > -- 
> > BOFH excuse #184:
> > 
> > loop found in loop in redundant loopback
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 


