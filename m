Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab0I0PsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:48:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63360 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab0I0PsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lBRIUwrSZ1hFnXMeondajkNORHh45iwr156JKsOSAe9ToqbS0N0RfnJRKdSKFOeqo0
         /rIcDzOwQF55OOpehMRrU+tgq2tTmuD+omX3s3YtqiCNGfEXxDCNvIBUV2dBzRsQQ2aa
         sHvEteRGTSekNsMGIW3lnPP7GhWcXSwlSJc2w=
Date: Mon, 27 Sep 2010 17:47:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb segv in the latest tip due to perf ctx changes
Message-ID: <20100927154750.GA5346@nowhere>
References: <20100924180417.GC1818@jolsa.brq.redhat.com> <4C9D0A82.5020406@windriver.com> <1285374560.2275.1054.camel@laptop> <20100925135532.GA5349@nowhere> <20100927081216.GC1829@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927081216.GC1829@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:12:16AM +0200, Jiri Olsa wrote:
> On Sat, Sep 25, 2010 at 03:55:35PM +0200, Frederic Weisbecker wrote:
> > On Sat, Sep 25, 2010 at 02:29:20AM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-09-24 at 15:30 -0500, Jason Wessel wrote:
> > > > Jiri,
> > > > 
> > > > Can you try this simple patch which is attached?
> > > > 
> > > > 
> > > > 
> > > > On 09/24/2010 01:04 PM, Jiri Olsa wrote:
> > > > > while starting kgdb early debug on latest tip tree,
> > > > > I got SIGSEGV inside kernel in following location:
> > > > >
> > > > >   
> > > > [clip]
> > > > > I found out it's due to foolowing commit, that's causing the init code
> > > > > to be called without the ctx field being defined...
> > > > >
> > > > > commit c3f00c70276d8ae82578c8b773e2db657f69a478
> > > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > Date:   Wed Aug 18 14:37:15 2010 +0200
> > > > >
> > > > >
> > > > >   
> > > > 
> > > > I took a look at the tip core, and the ctx parameter is no longer passed
> > > > into the perf_event_alloc() from perf_event_create_kernel_counter() kgdb
> > > > no longer gets it filled in for free.
> > > > 
> > > > The reality is that kgdb never had a true context or a way to mark the
> > > > hw breakpoint as a kernel only context for the hw breakpoint
> > > > reservations.  The patch is only a short term fix perhaps until on of
> > > > the perf guys explains the right way to use it. :-)
> > > 
> > > Argh, yes, its using the ctx rather early.. we cannot have a context
> > > before we've initialized the event, and here it looks like hw_breakpoint
> > > wants to use the context to initialize the event, chick, egg, etc..
> > > 
> > > Frederic, anything we can do about that?
> > 
> > 
> > 
> > Jason's patch is partially good, it just lacks one place to handle.
> > Jiri, can you test that?
> 
> it works ok
> 
> feel free to add
> Tested-by: Jiri Olsa <jolsa@redhat.com>
> 
> thanks,
> jirka


Actually I'm just realizing that, after the recent perf changes,
it does not only concern the early kgdb needs but every breakpoints
now that the context is found/allocated after the event gets initialized.

So I need to do a good bunch of changes in the breakpoints to fix that.

I'll come back with something.

Thanks.

