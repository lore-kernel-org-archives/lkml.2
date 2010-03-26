Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0CZKMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:12:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0CZKMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:12:46 -0400
Date: Fri, 26 Mar 2010 11:12:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts disabled
Message-ID: <20100326101241.GZ20695@one.firstfloor.org>
References: <20100326000325.917127328@linutronix.de> <20100326081457.GA23570@flint.arm.linux.org.uk> <20100326092023.GH27394@elte.hu> <20100326095929.063c5f63@lxorguk.ukuu.org.uk> <1269598133.12097.138.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269598133.12097.138.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:08:53AM +0100, Peter Zijlstra wrote:
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
> We've got local_irq_enable_in_hardirq() which should be used and can
> easily be grep'ed for.
> 
> But yes, I would much prefer to simply convert these known slow handlers
> to threaded interrupts.

That could be potentially hundreds in old obscure drivers all over the tree.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
