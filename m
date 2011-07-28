Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab1G1Nor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:44:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:45781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1G1Nop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:44:45 -0400
Subject: Re: [PATCH v2 3/6] trace: Add tracepoints to IRQ work run handler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20110728132938.GE11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-4-git-send-email-vnagarnaik@google.com>
	 <1311855171.2617.170.camel@laptop>
	 <20110728132938.GE11820@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 15:49:21 +0200
Message-ID: <1311860961.2617.175.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:29 +0200, Frederic Weisbecker wrote:
> On Thu, Jul 28, 2011 at 02:12:51PM +0200, Peter Zijlstra wrote:
> > On Wed, 2011-07-27 at 11:57 -0700, Vaibhav Nagarnaik wrote:
> > > @@ -122,6 +123,7 @@ void irq_work_run(void)
> > >  {
> > >         struct irq_work *list;
> > >  
> > >        trace_irq_work_run_entry(0);
> > >         if (this_cpu_read(irq_work_list) == NULL)
> > >                 return;
> > >  
> > > @@ -149,6 +151,7 @@ void irq_work_run(void)
> > >                               next_flags(NULL, IRQ_WORK_BUSY),
> > >                               NULL);
> > >         }
> > > +       trace_irq_work_run_exit(0);
> > >  }
> > >  EXPORT_SYMBOL_GPL(irq_work_run); 
> > 
> > So what happens when we call irq_work_run() from the timer interrupt?
> > 
> 
> We probably need something like:
> 
> void irq_work_run_interrupt(void)
> {
> 	trace_irq_work_run_entry(0);
> 	irq_work_run();
> 	trace_irq_work_run_exit(0);
> }

No we don't. That lives in arch code and its up to the arch to decide
where, when and how to call that.

On PPC for example that's hooked of the timer interrupt.

See here again your 'generalization' crap breaks down.

