Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab0CXUNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:13:00 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:34157 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932200Ab0CXUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:12:59 -0400
X-Greylist: delayed 2726 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2010 16:12:59 EDT
Date: Wed, 24 Mar 2010 15:27:28 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: rostedt@goodmis.org
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>
Message-ID: <1088471101.823551269458848070.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1269454428.2957.2890.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Steven Rostedt" <rostedt@goodmis.org> wrote:

> On Wed, 2010-03-24 at 18:35 +0100, John Kacur wrote:
> > Remove CONFIG_STACK_TRACER from DEBUG_COUNT so that reminder
> messages
> > are printed correctly, and don't leave an empty reminder block for
> example.
> > 
> 
> I think this should be attached to patch 1. Why have two patches for
> this?

Because patch 1 is a revert, I thought this makes the git history cleaner.

John

> 
> -- Steve
> 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  init/main.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/main.c b/init/main.c
> > index aa48b7b..17fd973 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -908,7 +908,7 @@ static int __init kernel_init(void * unused)
> >  	WARN_ON(irqs_disabled());
> >  #endif
> >  
> > -#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) +
> defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) +
> defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) +
> defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST)
> + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) +
> defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) -
> defined(CONFIG_FTRACE_MCOUNT_RECORD)))
> > +#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) +
> defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) +
> defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST)
> + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) +
> defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) +
> (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
> >  
> >  #if DEBUG_COUNT > 0
> >  	printk(KERN_ERR
> "*****************************************************************************\n");
