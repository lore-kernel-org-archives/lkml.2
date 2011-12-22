Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1LVInx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:43:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54411 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1LVInv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:43:51 -0500
Message-ID: <1324543413.24803.7.camel@twins>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Dec 2011 09:43:33 +0100
In-Reply-To: <20111222070212.GA9593@elte.hu>
References: <20111221105739.798864333@chello.nl>
	 <20111221111143.620776435@chello.nl>
	 <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
	 <20111222070212.GA9593@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 08:02 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Wed, Dec 21, 2011 at 2:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > >
> > > +#ifdef CONFIG_PRINTK_DEBUG
> > > +void printk_init(void)
> > > +{
> > > +       struct rq *rq;
> > > +       unsigned long flags;
> > > +
> > > +       local_irq_save(flags);
> > > +       rq = this_rq();
> > > +       raw_spin_lock(&rq->lock);
> > > +       printk(KERN_DEBUG "printk: echo echo echo..\n");
> > > +       raw_spin_unlock(&rq->lock);
> > > +       local_irq_restore(flags);
> > 
> > Ok, I can't really say that I think this is worth a config option like this.
> > 
> > Maybe an example module or something?

I really really really don't want to expose struct rq to modules, that's
just asking for trouble. But yeah, I know what you mean with not being
worth the config option, but then, I thought I might as well post it, it
can't be more horrible than the sem patch, can it ;-)

> > And I don't know *why*, but my immediate reaction to the 
> > message was that it either should be serious and say what it 
> > tested ("printk() works under rq lock"), or it should say 
> > "Bork bork bork". "echo echo echo" sounds just stupid.
> 
> We could perhaps use the standard mike test message:
> 
>   printk: Tap, tap, is this thing on?

Yeah, I clearly wasn't creative enough, I'm tempted to go with Linus'
suggestion though.
