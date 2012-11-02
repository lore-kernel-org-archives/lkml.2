Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217Ab2KBVty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:49:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:39337 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab2KBVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:49:51 -0400
Date: Fri, 2 Nov 2012 22:49:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: anish kumar <anish198519851985@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, mingo@kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH] IRQ CORE: irq_work_queue function return value not
 used.
In-Reply-To: <1351863814.4004.126.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1211022249150.2756@ionos>
References: <1351862676-5426-1-git-send-email-anish198519851985@gmail.com> <1351863814.4004.126.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Steven Rostedt wrote:

> On Fri, 2012-11-02 at 22:24 +0900, anish kumar wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> > As no one is using the return value of irq_work_queue function
> > it is better to just make it void.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Peter, like to take this patch? Or is there a reason you have for
> irq_work_queue() returning a value?
> 
> -- Steve
> 
> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> > ---
> >  kernel/irq_work.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> > index 1588e3b..a85c4b3 100644
> > --- a/kernel/irq_work.c
> > +++ b/kernel/irq_work.c
> > @@ -79,17 +79,17 @@ static void __irq_work_queue(struct irq_work *work)
> >   *
> >   * Can be re-enqueued while the callback is still in progress.
> >   */
> > -bool irq_work_queue(struct irq_work *work)
> > +void irq_work_queue(struct irq_work *work)
> >  {
> >  	if (!irq_work_claim(work)) {
> >  		/*
> >  		 * Already enqueued, can't do!
> >  		 */
> > -		return false;
> > +		return;
> >  	}
> >  
> >  	__irq_work_queue(work);
> > -	return true;
> > +	return;

And while at it please zap that pointless "return;" statement.

> >  }
> >  EXPORT_SYMBOL_GPL(irq_work_queue);
> >  
> 
> 
> 
