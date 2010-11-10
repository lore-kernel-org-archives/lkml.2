Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0KJWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:49:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0KJWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=anNpT3FC9Y6m9qSCWLFkgRxhzOzNdxtJDbSAxKXmA3wZ3gJ6x4f48MLiY48iw5YDC2
         AxbUJlebKG1e02vmNWr7dUALm0QRhb/vE/GV+pAU7bmw3yWjDwO2c1xLuIUYLGpoICu4
         blPjbRmCS5HXKLcaMEk1pmAD9m+4MzLs7mjOI=
Date: Wed, 10 Nov 2010 23:49:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101110224942.GB5355@nowhere>
References: <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <20101110213033.GA7682@nowhere> <1289426059.12418.209.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289426059.12418.209.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:54:19PM -0500, Steven Rostedt wrote:
> On Wed, 2010-11-10 at 22:30 +0100, Frederic Weisbecker wrote:
> > >     - 0 ns IRQ/SOFTIRQ handler duration side-effect
> > 
> > 
> > 
> > ditto.
> 
> If an interrupt (or softirq) preempts the recorded trace, then events
> that are recorded in that interrupt all get the same time as the event
> it preempted. Giving us the assumption that all events happened at once.
> 
> Again, this is just a side effect and the fix is trivial. But may
> require ABI breakage to do so.



Right, now I recall I discussed that with Mathieu lately.


 
> 
> > 
> > If we need/want to cure that, then we need an:
> > 
> > => ABI breakage
> > 
> > 
> > 
> > > - Event size limited to one page
> > 
> > 
> > 
> > Perf too needs more (userspace stack dumps).
> 
> That was actually a decision made by Linus. But is trivial to change. As
> there's nothing hard coded about the design that forces us to have page
> size sub buffers. I don't even think that it would require an ABI
> breakage, except I think my tools I wrote (incorrectly) assumed it.


Ok.



> 
> > 
> > 
> > 
> > > - Ftrace event headers are still too large
> > 
> > 
> > (described in the beginning)
> 
> Yep, they are large, but can be trimmed. This would require no abi
> breakage since the these headers are also described in the event
> formats. Thus changing the current tools should cope with the headers
> changing. In fact they were designed too since the lock-depth was known
> to be deprecated soon.


Hmm, in practice this is an ABI breakage as we have scripts that rely on
the common_pid field for example. We can fix this, but older tools won't
work with new kernels.



> > > - Handling of dynamically added instrumentation while trace is recorded is
> > >   inexistent.
> > 
> > 
> > 
> > 
> > I still don't understand this point
> 
> He's talking about tracing the tracepoints in a loaded module. We
> currently have no way to add them while a trace is happening. The trace
> formats do not exist and may not exist (if module is unloaded) when the
> trace ends.
> 
> But who really loads and then unloads a module during tracing. As pretty
> much all kernel developers cringe at the fact that modules get
> unloaded ;-)



Hehe :)

Anyway this can be expressed through an ABI extension,
using a kind of lazy tracepoint registration or so.

