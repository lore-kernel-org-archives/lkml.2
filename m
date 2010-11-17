Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725Ab0KQOjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:39:21 -0500
Received: from www.tglx.de ([62.245.132.106]:33351 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812Ab0KQOjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:39:18 -0500
Date: Wed, 17 Nov 2010 15:37:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
In-Reply-To: <1290003505.2109.833.camel@laptop>
Message-ID: <alpine.LFD.2.00.1011171529120.2900@localhost6.localdomain6>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>  <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>  <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>  <1290003110.2109.822.camel@laptop>
 <1290003505.2109.833.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Peter Zijlstra wrote:

> On Wed, 2010-11-17 at 15:11 +0100, Peter Zijlstra wrote:
> > The idea was to not let the filter engine work on the trace data (once
> > its gathered) but on the trace argument right at the beginning of the
> > tracepoint callchain, since some of the trace data is an expression of
> > the trace argument (say next->prio instead of next), the trace
> > expression wouldn't stay invariant, you'd have to write a different
> > filter for the same effect.
> > 
> > So I think it would be wise to make this change sooner rather than
> > later. 
> 
> Also, I see a lot of overlap with the dynamic probes stuff which needs
> the help of magic dwarves to come up with the right data to gather.
> 
> Merging the dynamic tracepoint and filter stuff would be nice, there's
> no way you can express next->prio without the help of these short
> buggers with large axes.
> 
> The trouble is that the dynamic tracepoint stuff is privileged for good
> reasons, try next+0x1000000 and you're out in the woods, priv. only
> filters otoh just doesn't sound too hot.
> 
> Another nasty thing is that you actually need to have these dwarves
> present, which means having the -debug package installed.

That sounds utterly insane for the basic use case where you trace
application context. There is no point to filter out the tracepoints,
really. Postprocessing can do that just fine.

I consider myself a power user of tracing, but hell I never used any
of those filters in a real use case. awk, grep, scripting languages do
just a better job and you don't miss any data just because you got
your filter expression slightly wrong. Postprocessing always wins in
that regard.

The only reason why these filters might make sense is to reduce the
trace volume on system wide traces in production environments, but
that's a completely different story. These scenarios can do with the
dynamic tracepoint stuff and the custom filtering w/o putting the
burden on the majority of users.

Thanks,

	tglx
