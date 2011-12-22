Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1LVHEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:04:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1LVHEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:04:07 -0500
Date: Thu, 22 Dec 2011 08:02:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
Message-ID: <20111222070212.GA9593@elte.hu>
References: <20111221105739.798864333@chello.nl>
 <20111221111143.620776435@chello.nl>
 <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Dec 21, 2011 at 2:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >
> > +#ifdef CONFIG_PRINTK_DEBUG
> > +void printk_init(void)
> > +{
> > +       struct rq *rq;
> > +       unsigned long flags;
> > +
> > +       local_irq_save(flags);
> > +       rq = this_rq();
> > +       raw_spin_lock(&rq->lock);
> > +       printk(KERN_DEBUG "printk: echo echo echo..\n");
> > +       raw_spin_unlock(&rq->lock);
> > +       local_irq_restore(flags);
> 
> Ok, I can't really say that I think this is worth a config option like this.
> 
> Maybe an example module or something?
> 
> And I don't know *why*, but my immediate reaction to the 
> message was that it either should be serious and say what it 
> tested ("printk() works under rq lock"), or it should say 
> "Bork bork bork". "echo echo echo" sounds just stupid.

We could perhaps use the standard mike test message:

  printk: Tap, tap, is this thing on?

Thanks,

	Ingo
