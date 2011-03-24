Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1CXFXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:23:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59494 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751489Ab1CXFXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:23:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18e8nhtDY8eijpBAbIVuxkYZUt6X8aHbPzvcUyn8/
	d4a8itCmCZlhtQ
Subject: Re: Linux 2.6.32.34
From: Mike Galbraith <efault@gmx.de>
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTin_UXOjnFuQ5DQgkYH1ZciVBa=3iQmcdUej6r=B@mail.gmail.com>
References: <20110323203426.GC7709@kroah.com>
	 <20110323203437.GD7709@kroah.com> <4D8A8DC9.1060502@suse.cz>
	 <AANLkTin_UXOjnFuQ5DQgkYH1ZciVBa=3iQmcdUej6r=B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 06:22:58 +0100
Message-ID: <1300944178.7409.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 11:39 +0800, Teck Choon Giam wrote:
> On Thu, Mar 24, 2011 at 8:18 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> > On 03/23/2011 09:34 PM, Greg KH wrote:
> >> --- a/kernel/perf_event.c
> >> +++ b/kernel/perf_event.c
> >> @@ -4167,6 +4167,8 @@ static void tp_perf_event_destroy(struct perf_event *event)
> >>
> >>  static const struct pmu *tp_perf_event_init(struct perf_event *event)
> >>  {
> >> +     if (event->hw.state & PERF_HES_STOPPED)
> >> +             return 0;
> >>       /*
> >>        * Raw tracepoint data is a severe data leak, only allow root to
> >>        * have these.
> >
> > This causes build to fail:
> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:
> > In function 'tp_perf_event_init':
> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> > error: 'struct hw_perf_event' has no member named 'state'
> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> > error: 'PERF_HES_STOPPED' undeclared (first use in this function)
> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> > error: (Each undeclared identifier is reported only once
> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> > error: for each function it appears in.)
> >
> >
> > The source:
> > commit 6f197b73304b3bd3d5a43b931383a5331d6b2987
> > Author: Frederic Weisbecker <fweisbec@gmail.com>
> > Date:   Mon Mar 7 21:27:09 2011 +0100
> >
> >    perf: Handle stopped state with tracepoints
> >
> >    commit a0f7d0f7fc02465bb9758501f611f63381792996 upstream.
> >
> >    We toggle the state from start and stop callbacks but actually
> >    don't check it when the event triggers. Do it so that
> >    these callbacks actually work.
> 
> It builds fine for me with gcc version 4.1.2 for both x86_32 and x86_64.

It won't if you turn tracing on.  hw_perf_event.state appeared in .37
via a4eaf7f1.

	-Mike

