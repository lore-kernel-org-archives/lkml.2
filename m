Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab0ELRLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:11:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0ELRLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:11:43 -0400
Date: Wed, 12 May 2010 19:11:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       arjan@infradead.org, ziga.mahkovec@gmail.com,
       davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512171129.GA17184@elte.hu>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
 <20100511213625.GD5422@nowhere>
 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
 <20100512144811.GA5405@nowhere>
 <1273678596.27703.30.camel@gandalf.stny.rr.com>
 <20100512164650.GH5405@nowhere>
 <1273683624.1626.127.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273683624.1626.127.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-12 at 18:46 +0200, Frederic Weisbecker wrote:
> > But there is no strong reason for perf record not to use splice,
> > a part the fact that perf doesn't support splice.
> 
> Its mostly an interface/api question. You cannot easily splice() a mmap()'ed 
> buffer on machines that have address constraints like sparc.
> 
> The thing I was thinking about is adding a new syscall that creates a single 
> buffer of specified size and provides a fd. Then use 
> PERF_EVENT_IOC_SET_OUTPUT, to connect an event to that fd/buffer and use 
> splice() on that fd.
> 
> It could reuse most of the perf buffer code, but simply not map it into 
> userspace and therefore not have the restriction on the vaddr.
> 
> Once you have that, a .splice_read implementation shouldn't be too hard.

That would be a really cool approach. Since most of the performance-sensitive 
streaming happens in the likes of perf record, the actual interface can be 
enhanced with no effect to the end user.

	Ingo
