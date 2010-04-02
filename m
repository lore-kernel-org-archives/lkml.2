Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0DBVco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:32:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:39995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0DBVcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:32:36 -0400
Subject: Re: [patch 1/2] genirq: Run irq handlers with interrupts disabled
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100402210916.GA23339@elf.ucw.cz>
References: <20100326000325.917127328@linutronix.de>
	 <20100326000405.758579387@linutronix.de>
	 <20100326061310.GV20695@one.firstfloor.org>
	 <alpine.LFD.2.00.1003261224070.3147@localhost.localdomain>
	 <20100330053325.GL20695@one.firstfloor.org>
	 <alpine.LFD.2.00.1003311315520.32352@localhost.localdomain>
	 <20100402093132.GA1360@ucw.cz>
	 <alpine.LFD.2.00.1004022242170.32352@localhost.localdomain>
	 <20100402210916.GA23339@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Apr 2010 23:31:16 +0200
Message-ID: <1270243876.5109.527.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 23:09 +0200, Pavel Machek wrote:
> On Fri 2010-04-02 22:42:51, Thomas Gleixner wrote:
> > On Fri, 2 Apr 2010, Pavel Machek wrote:
> > 
> > > On Wed 2010-03-31 13:16:37, Thomas Gleixner wrote:
> > > > On Tue, 30 Mar 2010, Andi Kleen wrote:
> > > > 
> > > > > > Why not simply force IRQF_DISABLED for all MSI interrupts. That still
> > > > > > allows nesting for non MSI ones, but it limits the chance of throwing
> > > > > > up reasonably well. That's a two liner.
> > > > > > 
> > > > > > Can you please test whether it resolves the issue at hand ?
> > > > > 
> > > > > Sorry for the late answer. Got confirmation that this patch
> > > > > fixes the test case. Thanks.
> > > > 
> > > > Ok, I'll push it linus wards and cc stable. I think thats the least
> > > > intrusive safe bet we can have right now.
> > > 
> > > stable? I'd say thats way too intrusive for -stable...
> > 
> > So we better let the possible stack overruns unaddressed ?
> 
> -stable should have no regressions, first and foremost. And this is
> pretty certain to introduce some, at least on low-powered system with
> serial ports.
> 
> So yes, it is probably better to let the possible stack overruns
> unaddressed. We have lived with them for 15 years or so...
> 
> (Alternatively, just make the irq stacks bigger? Or just take Andi's
> patch, which solves the overruns, and only introduces latency
> regressions when it would otherwise crash?)

You've got serial ports with MSI interrupts?
