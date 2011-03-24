Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1CXCvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:51:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:34044 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab1CXCvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:51:02 -0400
Date: Wed, 23 Mar 2011 19:51:33 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32.34
Message-ID: <20110324025133.GA23564@suse.de>
References: <20110323203426.GC7709@kroah.com>
 <20110323203437.GD7709@kroah.com>
 <4D8A8DC9.1060502@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D8A8DC9.1060502@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:18:17AM +0100, Jiri Slaby wrote:
> On 03/23/2011 09:34 PM, Greg KH wrote:
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -4167,6 +4167,8 @@ static void tp_perf_event_destroy(struct perf_event *event)
> >  
> >  static const struct pmu *tp_perf_event_init(struct perf_event *event)
> >  {
> > +	if (event->hw.state & PERF_HES_STOPPED)
> > +		return 0;
> >  	/*
> >  	 * Raw tracepoint data is a severe data leak, only allow root to
> >  	 * have these.
> 
> This causes build to fail:
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:
>  In function 'tp_perf_event_init':
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>  error: 'struct hw_perf_event' has no member named 'state'
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>  error: 'PERF_HES_STOPPED' undeclared (first use in this function)
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>  error: (Each undeclared identifier is reported only once
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>  error: for each function it appears in.)
> 
> 
> The source:
> commit 6f197b73304b3bd3d5a43b931383a5331d6b2987
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Mon Mar 7 21:27:09 2011 +0100
> 
>     perf: Handle stopped state with tracepoints
> 
>     commit a0f7d0f7fc02465bb9758501f611f63381792996 upstream.
> 
>     We toggle the state from start and stop callbacks but actually
>     don't check it when the event triggers. Do it so that
>     these callbacks actually work.

Ick, I don't know why it builds fine here.  Federic, should I just drop
this patch for the .32 tree?

thanks,

greg k-h
