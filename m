Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0CYLQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:16:50 -0400
Received: from www.tglx.de ([62.245.132.106]:52285 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0CYLQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:16:48 -0400
Date: Thu, 25 Mar 2010 12:16:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100325105033.35bceffd@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003251211350.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325105033.35bceffd@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Alan Cox wrote:

> > Which leads to the general question why we have that IRQF_DISABLED
> > shite at all. AFAICT the historical reason were IDE drivers, but we
> > grew other abusers like USB, SCSI and other crap which runs hard irq
> > handlers for hundreds of micro seconds in the worst case.
> 
> Anyone you've forgotten to offend ?

Hmm, not sure. Have not measured IRQ handler run times for quite a
while :)

> Pretty much the only 'core' driver today which enables IRQs in the irq
> handlers and needs it is the old IDE layer. There are also a couple of
> drivers which play games with disable/enable_irq in the IRQ paths for
> other reasons (lack of irq threads when written and a hardware model thats
> totally SMP unfriendly). 8390 is the obvious one here and it at least
> would be far far saner using threaded IRQs and normal locking with IRQs
> unmasked.

Right, but that's not the problem here. We talk about a (hopefully)
well written interrupt handler which runs for a very short
time. What's the point of running it with interrupts enabled ?
Nothing, we just run into stack overflow problems. So what's better:
an unreliable and ugly hackaround or just avoiding the possible stack
overflow in the first place ?

Thanks,

	tglx


