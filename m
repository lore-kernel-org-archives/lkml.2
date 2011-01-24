Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1AXXGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:06:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40434 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1AXXGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Ns2GpMkHO6frMu9jSDBMZ5jFxlSEBxYdZXziCqM75odCJKdNy+5VOtW3y4ywg5F0fp
         pVyAScQpwIRVeRC2W3Ki+DCjgXWRjBlIvRiGYZU8s0CXk+CO1imILpV6uLMytaEDKTv3
         /Bf0y8oo33Hiy7PXCMvSJ99QbSSRL059wH15s=
Date: Mon, 24 Jan 2011 21:05:53 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        tardyp@gmail.com, jean.pihet@newoldbits.com,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Perf ABI versioning
Message-ID: <20110124230553.GF6367@ghostprotocols.net>
References: <201101241704.01021.trenn@suse.de>
 <201101242249.14471.trenn@suse.de>
 <20110124215755.GE6367@ghostprotocols.net>
 <201101242330.03008.trenn@suse.de>
 <20110124224610.GF2318@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124224610.GF2318@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 24, 2011 at 11:46:12PM +0100, Frederic Weisbecker escreveu:
> On Mon, Jan 24, 2011 at 11:30:01PM +0100, Thomas Renninger wrote:
> > On Monday 24 January 2011 22:57:55 Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Jan 24, 2011 at 10:49:13PM +0100, Thomas Renninger escreveu:
> > ... 
> > > Using the /format file hashed as peterz said is elegant, fine grained
> > > content based ABI number :-)
> > Ok thanks, I should have had a closer look at the binary format.
> > 
> > It may make sense at some time to provide a library so that other tools
> > can make use of the most convenient functions in tools/perf/utils/*
> > as well?
> 
> I personally wish the other way around: having Pytimechart merged in perf :)
> If I remember correctly, the problem was that we don't have support for
> trace_printk with perf?
> 
> But sure if more out of tree tools show up and want to use tracepoints,
> we can think about librarizing it.
> 
> (Even though my secret hope is that
> we build a nice one tool that can answer most tracing needs together rather
> than many scattered ad hoc pieces.)

Yes, there is this conflict of tools/perf/ people coming from the
kernel, where we can change APIs as we see fit as long as we pay the
price of going over the users to fix them up.

And the desire of having something that can be used by projects living
outside the kernel source repo.

There are at least two efforts underway that are paving the way to
having something usable by third parties, Borislav Petkov's patchseries
to have some liblk/libtrace and my work for .39 to have a python perf.so
binding.

I think we should try as hard as possible to get things in tools/ so
that we have as long an experience in trying to get good abstractions as
possible before we decide on a v1 "outsiders API" :-)

- Arnaldo

P.S. Most of my work is in my perf/core branch in my git.k.o tree,
both mine and Borislavs are a wersearch away :)
