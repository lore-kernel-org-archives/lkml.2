Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0CZKys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:54:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760Ab0CZKyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:41 -0400
Date: Fri, 26 Mar 2010 11:53:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Nicolas Pitre <nico@fluxnic.net>, Linus Torvalds <torvalds@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts
 disabled
Message-ID: <20100326105358.GA4424@elte.hu>
References: <20100326000325.917127328@linutronix.de>
 <20100326081457.GA23570@flint.arm.linux.org.uk>
 <20100326092023.GH27394@elte.hu>
 <20100326095929.063c5f63@lxorguk.ukuu.org.uk>
 <1269598133.12097.138.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269598133.12097.138.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-03-26 at 09:59 +0000, Alan Cox wrote:
> > > As long as it's rare (which it is) i dont see a problem: you can enable 
> > > interrupts in the handler by using local_irq_enable(), like the IDE PIO 
> > > drivers do. That way it's documented a bit better as well, because it shows 
> > > the precise source of the latency, with a big comment explaining it, etc.
> > 
> > I don't think it's as rare as you think particularly in embedded, and the 
> > moment you start explicitly using local_irq_enable() you've simply moved 
> > the underlying problem back and made it far harder to grep for.
> 
> We've got local_irq_enable_in_hardirq() which should be used and can easily 
> be grep'ed for.
> 
> But yes, I would much prefer to simply convert these known slow handlers to 
> threaded interrupts.

Yeah, agreed. So there's multiple solutions:

 - On old hw with a driver that nobody is willing to convert to threaded IRQs: 
   use the existing local_irq_enable_in_hardirq() API. This preserves the 
   status quo.

 - On new hw with new drivers where there's such a level of IRQ parallelism 
   that enabling IRQs in hardirqs is not an option, use threaded IRQ handlers.

Thanks,

	Ingo
