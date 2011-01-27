Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1A0RHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1A0RHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:07:41 -0500
Date: Thu, 27 Jan 2011 17:59:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110127165923.GA28172@redhat.com>
References: <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com> <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop> <20110126211931.GA6778@redhat.com> <20110126213317.GA7403@redhat.com> <1296124337.15234.71.camel@laptop> <1296131387.15234.142.camel@laptop> <20110127161047.GB25060@redhat.com> <1296145674.15234.238.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296145674.15234.238.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Peter Zijlstra wrote:
>
> On Thu, 2011-01-27 at 17:10 +0100, Oleg Nesterov wrote:
> > >  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> > >       local_irq_enable();
> > > +     rq->in_ctxsw = 0;
> >
> > If we think that context_switch finishes here, probably it would be
> > more clean to clear ->in_ctxsw before local_irq_enable().
>
> It must in fact be done before,

Yes, I alredy realized this when I was reading another email from you.

> > But, otoh, maybe finish_lock_switch() can clear in_ctxsw, it already
> > checks __ARCH_WANT_INTERRUPTS_ON_CTXSW. Likewise, perhaps it can be
> > set in prepare_lock_switch() which enables irqs.
> >
> > But this is cosmetic and up to you.
>
> Can't do because of the above thing..

Right.

Oleg.

