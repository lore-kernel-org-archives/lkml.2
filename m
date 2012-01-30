Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2A3Np3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:45:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:34223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2A3Np2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:45:28 -0500
Message-ID: <1327931107.2446.205.camel@twins>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Steets <asteets@rgmadvisors.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 30 Jan 2012 14:45:07 +0100
In-Reply-To: <20120130113115.GA6565@elte.hu>
References: <4F22D8D9.3010108@rgmadvisors.com>
	 <20120128120151.GA10390@elte.hu> <4F248938.5030507@rgmadvisors.com>
	 <20120129163235.GB23408@elte.hu> <1327917156.2446.191.camel@twins>
	 <20120130101121.GB8924@elte.hu> <1327921293.2446.202.camel@twins>
	 <20120130113115.GA6565@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 12:31 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Mon, 2012-01-30 at 11:11 +0100, Ingo Molnar wrote:
> > > So, what workflow are you suggesting to Andrew?
> > 
> > Librarize perf record, then in your code do something like:
> > 
> > #include "perf_record.h"
> 
> Maybe. (and then it shouldnt be limited to perf_record.h but 
> should be events.h plus libevents.so or such)

Yes it should be, you want to reserve the more generic name for less
narrow interfaces.

> > 
> >   handle = perf_record_init(); /* creates perf events and creates
> >                                   a record thread that writes samples
> >                                   to perf.data, consumes env(PERF_*)
> >                                   for configuration, registers with
> >                                   at_exit() for cleanup */
> >   if (!handle)
> >     /* burn */
> > 
> >   /* do you other code */
> > 
> >   perf_record_start(handle);
> > 
> >   /* do the bit you want profiled */
> > 
> >   perf_record_stop(handle);
> > 
> > Then build with -lperfrecord or so. Not too hard, right?
> 
> Isnt a simple prctl() so much easier and faster?

I really don't want to add another two prctl()s for this, ideally I'd
remove the ones we have now, but I've never done due to maintaining
backwards blah..

> What's your concern with the prctl()? This would arguably be the 
> right kind of usage for prctl(): it's an established API/ABI for 
> process/task-wide settings.

Its doing things backwards, also the whole concept of allowing people to
hide things from a profiler is so rotten I'm not willing to even
consider the notion.
