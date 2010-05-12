Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0ELRA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:00:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab0ELRAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:00:25 -0400
Date: Wed, 12 May 2010 18:59:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Pierre Tardy <tardyp@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       arjan@infradead.org, ziga.mahkovec@gmail.com
Subject: Re: [RFC] PyTimechart
Message-ID: <20100512165947.GA11921@elte.hu>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
 <20100511213625.GD5422@nowhere>
 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
 <20100512144811.GA5405@nowhere>
 <1273678596.27703.30.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273678596.27703.30.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-05-12 at 16:48 +0200, Frederic Weisbecker wrote:
> > On Wed, May 12, 2010 at 03:37:27PM +0200, Pierre Tardy wrote:
> 
> > But we don't yet support trace_printk in perf. May be we could wrap
> > them in trace events.
> 
> Hmm, do we really want to do that?
> 
> We really need to get the perf and ftrace trace buffers combined. I 
> understand why perf chose to do the mmap buffers for the counting, but for 
> live streaming, it is very inefficient compared to splice.

The thing is that for a very long time ftrace didnt have splice support and 
survived just fine. Even today most of the ftrace usage isnt utilizing splice.

Yes, splice might help in some situations but on average it's an independent 
speedup on the order of magnitude of a few percents, not a 'must have' item.

So please keep these issues separate.

Thanks,

	Ingo
