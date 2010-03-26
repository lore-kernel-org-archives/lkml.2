Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab0CZMCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:02:51 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36531 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0CZMCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:02:48 -0400
Date: Fri, 26 Mar 2010 12:02:28 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nicolas Pitre <nico@fluxnic.net>, Linus Torvalds <torvalds@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts disabled
Message-ID: <20100326120228.GC19308@shareable.org>
References: <20100326000325.917127328@linutronix.de> <20100326081457.GA23570@flint.arm.linux.org.uk> <20100326092023.GH27394@elte.hu> <1269595692.12097.128.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269595692.12097.128.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-03-26 at 10:20 +0100, Ingo Molnar wrote:
> > * Russell King <rmk@arm.linux.org.uk> wrote:
> > 
> > > On Fri, Mar 26, 2010 at 12:06:44AM -0000, Thomas Gleixner wrote:
> > > > The following patch series removes the IRQF_DISABLED functionality
> > > > from the core interrupt code and runs all interrupt handlers with
> > > > interrupts disabled.
> > > 
> > > As was covered in previous discussions, what about drivers such as SMC91x 
> > > which take a long time to retrieve packets from the hardware? Always running 
> > > handlers with IRQs disabled will kill things such as serial on these 
> > > platforms.
> > 
> > As long as it's rare (which it is) i dont see a problem: you can enable 
> > interrupts in the handler by using local_irq_enable(), like the IDE PIO 
> > drivers do. That way it's documented a bit better as well, because it shows 
> > the precise source of the latency, with a big comment explaining it, etc.
> 
> Or alternatively, use threaded interrupts for such slow hardware.

What is the latency of threaded interrupts these days, compared with
non-threaded interrupts?

Slow hardware is quite sensitive to increases in latency.  Obviously
not a problem for the sources of latency: it's a problem for the irq
which is _sensitive_ to latency caused by the other one.  That is
typically a serial port or something.

But the benefit of kernel-settable interrupt priorities (i.e. due to
the threads) may be worth it even for serial ports.  I would love to
see some measurements comparing with and without.

-- Jamie
