Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab0EYUU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:20:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab0EYUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eyIoUlJzbubFKBsDAI+kXjjOEIR9zKYZhoqbcWQRNwrGbyT4lk8UOEgvijIcwbHfFR
         D88mRit5UOceilY1KlaOlIFTKuWeMW5Bqk2TPScLLTTFjwd4JFeSFfka84SEED52dea0
         WTPxYSZXsWasftcRWoAhGHml5qYWxOOSFGc4s=
Date: Tue, 25 May 2010 22:20:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Cc: rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: Tracing configuration review
Message-ID: <20100525202047.GC5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu> <1274816768.22648.220.camel@gandalf.stny.rr.com> <1274817498.9346.5.camel@cndougla-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274817498.9346.5.camel@cndougla-ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 03:58:18PM -0400, Chase Douglas wrote:
> On Tue, 2010-05-25 at 15:46 -0400, Steven Rostedt wrote:
> > On Tue, 2010-05-25 at 15:31 -0400, Chase Douglas wrote:
> > > Hi all,
> > > 
> > > I'm going through our Ubuntu kernel configuration for our next release
> > > to ensure we have all the trace options enabled that may be useful. I
> > > have a few questions about what tracer options we should have enabled.
> > > 
> > > Our guiding principle in regards to these options is: if an option can
> > > be turned on and has no performance impact unless explicitly enabled on
> > > the kernel command line or at runtime, we are happy to enable it.
> > > Secondarily, we don't want to enable options that are headed for
> > > deprecation.
> > > 
> > > The following options are what I am looking to set for our x86
> > > configurations. I've only included those that I am not 100% sure of.
> > > Comments are what I could gather from documentation and Kconfig, but
> > > they may not be accurate:
> > > 
> > > # CONFIG_IRQSOFF_TRACER is not set (performance impact by default)
> > 
> > Correct, keep that off.
> > 
> > > # CONFIG_SYSPROF_TRACER is not set (don't know much about this)
> > 
> > Neither do I ;-)
> > 
> > 
> > > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> > 
> > Although it is headed for deprecation, I think it still gets set by
> > other tracers, since it has the code to initiate the comm reader.
> > 
> > > CONFIG_FTRACE_SYSCALLS=y (no performance impact by default)
> > 
> > Correct
> > 
> > > CONFIG_BOOT_TRACER=y (no performance impact by default)
> > 
> > But this tracer is pretty useless. It gives no more information than
> > debug_initcalls.
> > 
> > > CONFIG_KSYM_TRACER=y (no performance impact by default)
> > 
> > Yep
> > 
> > > # CONFIG_STACK_TRACER is not set (Kconfig says N if unsure)
> > 
> > I would set this if you already have the function tracer. It gives no
> > more overhead than that, and it is very useful.
> > 
> > > # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)
> > 
> > Don't know.
> > 
> > > CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)
> > > 
> > > Lastly, what options are safe for performance when
> > > HAVE_DYNAMIC_FTRACE=n, like on our ARM kernels. It is not clear to me
> > > through what's in Documentation/trace/* and the Kconfig entries what
> > > options could cause a performance decrease due to the inability to
> > > dynamically enable and disable tracing at runtime.
> > 
> > HAVE_DYNAMIC_FTRACE affects the function tracer. If you do not have
> > that, then do not enable FUNCTION_TRACER or anything that depends on it.
> > 
> > Also note, FUNCTION_TRACER depends on FRAME_POINTERS. Your millage may
> > vary with that. If you already have FRAME_POINTERS on, and the arch
> > supports DYNAMIC_FTRACE, then its fine to have FUNCTION_TRACER and all
> > those that are built on top (STACK_TRACER, FUNCTION_GRAPH, etc)
> 
> (I would have snipped much of the above, but since I've added CC for the
> Ubuntu list I wanted to leave it as is for this first reply)
> 
> After enabling KSYM_TRACER, I was presented with PROFILE_KSYM_TRACER.
> This is also "Say N if unsure," so I could use some guidance on whether
> we should turn it on as well.



KSYM_TRACER traces memory accesses (using breakpoints) and display each
of these in the trace/trace_pipe files. PROFILE_KSYM_TRACER produces
basic statistics on top of these traces.

But both are deprecated really, the perf tools interface is much
better for this job.

