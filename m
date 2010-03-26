Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0CZJWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 05:22:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0CZJWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 05:22:42 -0400
Date: Fri, 26 Mar 2010 10:20:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts
 disabled
Message-ID: <20100326092023.GH27394@elte.hu>
References: <20100326000325.917127328@linutronix.de>
 <20100326081457.GA23570@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326081457.GA23570@flint.arm.linux.org.uk>
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


* Russell King <rmk@arm.linux.org.uk> wrote:

> On Fri, Mar 26, 2010 at 12:06:44AM -0000, Thomas Gleixner wrote:
> > The following patch series removes the IRQF_DISABLED functionality
> > from the core interrupt code and runs all interrupt handlers with
> > interrupts disabled.
> 
> As was covered in previous discussions, what about drivers such as SMC91x 
> which take a long time to retrieve packets from the hardware? Always running 
> handlers with IRQs disabled will kill things such as serial on these 
> platforms.

As long as it's rare (which it is) i dont see a problem: you can enable 
interrupts in the handler by using local_irq_enable(), like the IDE PIO 
drivers do. That way it's documented a bit better as well, because it shows 
the precise source of the latency, with a big comment explaining it, etc.

Thanks,

	Ingo
