Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1G1NbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:31:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58703 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1G1NbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:31:03 -0400
Date: Thu, 28 Jul 2011 15:29:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 3/6] trace: Add tracepoints to IRQ work run handler
Message-ID: <20110728132938.GE11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1311793038-15155-4-git-send-email-vnagarnaik@google.com>
 <1311855171.2617.170.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311855171.2617.170.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 02:12:51PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-27 at 11:57 -0700, Vaibhav Nagarnaik wrote:
> > @@ -122,6 +123,7 @@ void irq_work_run(void)
> >  {
> >         struct irq_work *list;
> >  
> >        trace_irq_work_run_entry(0);
> >         if (this_cpu_read(irq_work_list) == NULL)
> >                 return;
> >  
> > @@ -149,6 +151,7 @@ void irq_work_run(void)
> >                               next_flags(NULL, IRQ_WORK_BUSY),
> >                               NULL);
> >         }
> > +       trace_irq_work_run_exit(0);
> >  }
> >  EXPORT_SYMBOL_GPL(irq_work_run); 
> 
> So what happens when we call irq_work_run() from the timer interrupt?
> 

We probably need something like:

void irq_work_run_interrupt(void)
{
	trace_irq_work_run_entry(0);
	irq_work_run();
	trace_irq_work_run_exit(0);
}
