Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab0KQNnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:43:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56541 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0KQNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kkobjLE9pmTkQigxE62ryc4s2I+dpwwEKn1C/s3O2Qjhi4W9EbaGllcfBpbOnqXEOd
         rLQSTo+ocLogXQPN/z6ZTcvGd61lrz+yvIrO1Hgvq9Sm4zkIXY3Od4LVCjo3GfIcI78W
         89Ec6GqziGy37pq7q0jfTpDLtoXJdTxvDf+aI=
Date: Wed, 17 Nov 2010 14:43:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117134300.GG5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere> <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop> <20101117125344.GC5464@nowhere> <1289998957.2109.751.camel@laptop> <20101117131023.GE27063@elte.hu> <1290000976.2109.782.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290000976.2109.782.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 02:36:16PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 14:10 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, 2010-11-17 at 13:53 +0100, Frederic Weisbecker wrote:
> > > > On Wed, Nov 17, 2010 at 12:35:50PM +0100, Peter Zijlstra wrote:
> > > > > On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
> > > > > > > For example I'm currently working with dozens of trace_printk() and I would be 
> > > > > > > very happy to turn some of them off half of the time.
> > > > > > 
> > > > > > I guess we could try such a patch. If you send a prototype i'd be interested in 
> > > > > > testing it out.
> > > > > 
> > > > > I don't see the point, the kernel shouldn't contain any trace_printk()s
> > > > > to begin with..
> > > > 
> > > > 
> > > > It's oriented toward developers. Those who use dozens of tracepoints in
> > > > their tree because they are debugging something or developing a new feature,
> > > > they might to deactivate/reactivate some of these independant points.
> > > > 
> > > > This can also apply to dynamic_printk of course.
> > > > 
> > > > Well, the very first and main point is to standardize trace_printk into
> > > > a trace event so that it gets usable by perf tools. I have been asked many
> > > > times "how to use trace_printk() with perf?".
> > > 
> > > Thing is, since its these dev who add the trace_printk()s to begin with, I don't 
> > > see the point in splitting them out, if you didn't want them why did you add them 
> > > to begin with?!
> > 
> > That's a common workflow: lots of printks (trace_printk's) put all around the code - 
> > and sometimes one set of tracepoints is needed, one time another set.
> > 
> > _If_ we succeed in presenting them like Frederic suggested it, and if we make the 
> > turning on/off _simpler_ (no kernel modification) and faster (no kernel reboot) via 
> > the tooling, people like Frederic might start using it.
> > 
> > I dont think we should fight the workflow itself - it makes sense.
> > 
> > The only question is whether we can represent it all in a nicer fashion than 'modify 
> > the source code and reboot'. If we cannot then there's no point - but i'm not sure 
> > about it and Frederic seems to be convinced too that he can make such a switch 
> > on/off facility intuitive. We'll only see if we try it.
> > 
> > Also, i dont see any harm - do you?
> 
> Yes, trace_printk() is a pure debug interface, solely meant for the edit
> + reboot cycle.

So why prevent from making it even more handy?


> If you want anything more than that we've got tracepoints. The rule up
> until now has been to never merge a trace_printk() user.

Sure, that doesn't change the core idea of trace_prink(): none of them must
be merged. That new event interface would just make private uses of trace_printk()
more convenient.

