Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1LVJF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:05:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1LVJFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:05:53 -0500
Date: Thu, 22 Dec 2011 10:03:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
Message-ID: <20111222090352.GA11831@elte.hu>
References: <20111221105739.798864333@chello.nl>
 <20111221111143.620776435@chello.nl>
 <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
 <20111222070212.GA9593@elte.hu>
 <1324543413.24803.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324543413.24803.7.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-12-22 at 08:02 +0100, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Wed, Dec 21, 2011 at 2:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > >
> > > >
> > > > +#ifdef CONFIG_PRINTK_DEBUG
> > > > +void printk_init(void)
> > > > +{
> > > > +       struct rq *rq;
> > > > +       unsigned long flags;
> > > > +
> > > > +       local_irq_save(flags);
> > > > +       rq = this_rq();
> > > > +       raw_spin_lock(&rq->lock);
> > > > +       printk(KERN_DEBUG "printk: echo echo echo..\n");
> > > > +       raw_spin_unlock(&rq->lock);
> > > > +       local_irq_restore(flags);
> > > 
> > > Ok, I can't really say that I think this is worth a config option like this.
> > > 
> > > Maybe an example module or something?
> 
> I really really really don't want to expose struct rq to 
> modules, that's just asking for trouble. But yeah, I know what 
> you mean with not being worth the config option, but then, I 
> thought I might as well post it, it can't be more horrible 
> than the sem patch, can it ;-)

Could be made part of the locking self-tests - that way it does 
not add an extra config option! ;-)

Thanks,

	Ingo
