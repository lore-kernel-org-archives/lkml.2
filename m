Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab0I0IMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758899Ab0I0IMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:12:30 -0400
Date: Mon, 27 Sep 2010 10:12:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb segv in the latest tip due to perf ctx changes
Message-ID: <20100927081216.GC1829@jolsa.brq.redhat.com>
References: <20100924180417.GC1818@jolsa.brq.redhat.com>
 <4C9D0A82.5020406@windriver.com>
 <1285374560.2275.1054.camel@laptop>
 <20100925135532.GA5349@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925135532.GA5349@nowhere>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 03:55:35PM +0200, Frederic Weisbecker wrote:
> On Sat, Sep 25, 2010 at 02:29:20AM +0200, Peter Zijlstra wrote:
> > On Fri, 2010-09-24 at 15:30 -0500, Jason Wessel wrote:
> > > Jiri,
> > > 
> > > Can you try this simple patch which is attached?
> > > 
> > > 
> > > 
> > > On 09/24/2010 01:04 PM, Jiri Olsa wrote:
> > > > while starting kgdb early debug on latest tip tree,
> > > > I got SIGSEGV inside kernel in following location:
> > > >
> > > >   
> > > [clip]
> > > > I found out it's due to foolowing commit, that's causing the init code
> > > > to be called without the ctx field being defined...
> > > >
> > > > commit c3f00c70276d8ae82578c8b773e2db657f69a478
> > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Date:   Wed Aug 18 14:37:15 2010 +0200
> > > >
> > > >
> > > >   
> > > 
> > > I took a look at the tip core, and the ctx parameter is no longer passed
> > > into the perf_event_alloc() from perf_event_create_kernel_counter() kgdb
> > > no longer gets it filled in for free.
> > > 
> > > The reality is that kgdb never had a true context or a way to mark the
> > > hw breakpoint as a kernel only context for the hw breakpoint
> > > reservations.  The patch is only a short term fix perhaps until on of
> > > the perf guys explains the right way to use it. :-)
> > 
> > Argh, yes, its using the ctx rather early.. we cannot have a context
> > before we've initialized the event, and here it looks like hw_breakpoint
> > wants to use the context to initialize the event, chick, egg, etc..
> > 
> > Frederic, anything we can do about that?
> 
> 
> 
> Jason's patch is partially good, it just lacks one place to handle.
> Jiri, can you test that?

it works ok

feel free to add
Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
