Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab0KQOKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:10:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0KQOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UfCvVNUsoex4c5Uz6iTzGMlXYrdGDsn5NGih4eCV6NMa0LBrxqukpbZODYg/FY7YE6
         7/t3KI+qfXyUQuMHuNxLD9fwdSlMoua7T+6j1qIeOa4GVE4VYLJ87bqKJjbqSTPwEDZ5
         S/X4ohAeR48YAs2YVK2wINP4S+Jkv3fGyjuu0=
Date: Wed, 17 Nov 2010 15:10:33 +0100
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
Message-ID: <20101117141031.GH5464@nowhere>
References: <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere> <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop> <20101117125344.GC5464@nowhere> <1289998957.2109.751.camel@laptop> <20101117131023.GE27063@elte.hu> <1290000976.2109.782.camel@laptop> <20101117134300.GG5464@nowhere> <1290002029.2109.799.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290002029.2109.799.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 02:53:49PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 14:43 +0100, Frederic Weisbecker wrote:
> > 
> > > Yes, trace_printk() is a pure debug interface, solely meant for the edit
> > > + reboot cycle.
> > 
> > So why prevent from making it even more handy?
> > 
> > 
> > > If you want anything more than that we've got tracepoints. The rule up
> > > until now has been to never merge a trace_printk() user.
> > 
> > Sure, that doesn't change the core idea of trace_prink(): none of them must
> > be merged. That new event interface would just make private uses of trace_printk()
> > more convenient. 
> 
> I don't get it, if you don't want it, why put it there in the first
> place?
> 
> I've never found myself thinking, oh damn, I didn't want to see that
> one!, only damn, I should have added more :-)


Hehe :)

Yeah I have a strange workflow. I'm working on that CPU isolation thing
and I have dozens of trace_printk all over the place for tons of
things. And everytime I remove one to unwind some output or to focus
on another one, I often have to restore it later because I need it
again. Usually I even just comment it out instead of removing it.

If I could make this dynamically on a per line filtering, or sometimes on
a per file granularity (as both are equally often the case for me), I would
probably win some time.

I just don't know how many developers have a similar workflow than mine.

