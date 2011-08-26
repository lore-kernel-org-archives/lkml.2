Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1HZQJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:09:44 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:56521 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HZQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:09:42 -0400
Date: Fri, 26 Aug 2011 09:09:06 -0700
From: Brad Boyer <flar@allandria.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
Message-ID: <20110826160905.GA17550@cynthia.pants.nu>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
 <alpine.OSX.2.00.1106011300550.199@ibook.intranet>
 <20110605062702.GA2034@cynthia.pants.nu>
 <CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com>
 <alpine.OSX.2.00.1108102007430.203@ibook.local>
 <CAMuHMdXgeHtOB_3u6G6N9E4vaq=sJY-9NtF68XAnxhspMgRyGg@mail.gmail.com>
 <alpine.OSX.2.00.1108262117070.267@ibook.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1108262117070.267@ibook.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 09:21:05PM +1000, Finn Thain wrote:
> 
> On Fri, 26 Aug 2011, Geert Uytterhoeven wrote:
> 
> > According to via_register_interrupts(), it requests both:
> > 
> >         if (via_alt_mapping) {
> >                 if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
> >                                 (void *)via1))
> >                         pr_err("Couldn't register %s interrupt\n", "software");
> >                 if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)via1))
> >                         pr_err("Couldn't register %s interrupt\n", "via1");
> >         } else {
> >                 if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)via1))
> >                         pr_err("Couldn't register %s interrupt\n", "via1");
> >         }
> > 
> > Hence IRQ_AUTO_1 must be shared and we cannot use an optimized chain
> > handler for via1_irq()
> 
> I'm pretty sure that the "software" request_irq can be removed. It has 
> come up before --
> http://marc.info/?l=linux-mac68k&m=110973724208746&w=2
> 
> Maybe Brad can shed some light on this (?)

Sorry, not really. We don't have any good documentation on how the
alternate mapping really works on those systems. Anything that has
it internally is using custom chips instead of a real VIA6522, so
it's hard to say exactly how it behaves.

The real key of the alternate mapping is to move the timer interrupt
higher than all the other hardware. This and the ADB are about all
we really need from VIA1. It's possible one of the other interrupts
we don't use is still on IRQ1. It's hard to say without trying.

I think I have a couple systems that have this hardware, but they
are ones I haven't used much. If I can find some time I'll get the
Q950 I acquired recently up and running since it should have the
alternate mapping capability.

One potential option is to just take it out and see if anything
breaks with the change. We could add it back later if we find a
use for it.

	Brad Boyer
	flar@allandria.com

