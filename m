Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0LVQMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:12:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0LVQMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:12:47 -0500
Date: Wed, 22 Dec 2010 17:12:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, srostedt@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tracing: Only trace sched_wakeup if it actually
 work something up
Message-ID: <20101222161232.GA20358@elte.hu>
References: <tip-14bc7a06c6175cfa8070a5f5022210b648c3e0a7@git.kernel.org>
 <1293023945.2170.121.camel@laptop>
 <1293025587.22905.128.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293025587.22905.128.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-12-22 at 14:19 +0100, Peter Zijlstra wrote:
> > On Wed, 2010-12-22 at 13:16 +0000, tip-bot for Steven Rostedt wrote:
> > > Commit-ID:  14bc7a06c6175cfa8070a5f5022210b648c3e0a7
> > > Gitweb:     http://git.kernel.org/tip/14bc7a06c6175cfa8070a5f5022210b648c3e0a7
> > > Author:     Steven Rostedt <srostedt@redhat.com>
> > > AuthorDate: Thu, 2 Dec 2010 16:56:14 -0500
> > > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > > CommitDate: Fri, 3 Dec 2010 10:46:59 -0500
> > > 
> > > tracing: Only trace sched_wakeup if it actually work something up
> > > 
> > > Currently the tracepoint sched_wakeup traces the wakeup event even
> > > if the wakeup failed to wake anything up. This is quite stupid
> > > but it happens because we did not want to add a conditional
> > > to the core kernel code that would just slow down the wakeup events.
> > > 
> > > This patch changes the wakeup tracepoints to use the
> > > 
> > >  DEFINE_EVENT_CONDITIONAL()
> > > 
> > > to test the "success" parameter and will only trace the event if
> > > the wakeup was successfull.
> > > 
> > > The success field in the tracepoint is removed since it is no
> > > longer needed.
> > 
> > I NAKed this, its stupid.
> 
> I wouldn't call it stupid, but unnecessary, yes.
> 
> Anyway, it was the last patch of the series.
> 
> Ingo, can you revert this last patch?

Yeah, done.

Thanks guys,

	Ingo
