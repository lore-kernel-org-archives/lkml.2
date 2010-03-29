Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0C2RUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:20:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:51024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0C2RUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:20:14 -0400
Subject: Re: [PATCH 1/2] perf: Correctly align perf event tracing buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100329171615.GA5101@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
	 <1269753066-17246-2-git-send-regression-fweisbec@gmail.com>
	 <1269852691.12097.162.camel@laptop>  <20100329171615.GA5101@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 19:20:09 +0200
Message-ID: <1269883209.12097.366.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 19:16 +0200, Frederic Weisbecker wrote:
> On Mon, Mar 29, 2010 at 10:51:31AM +0200, Peter Zijlstra wrote:
> > On Sun, 2010-03-28 at 07:11 +0200, Frederic Weisbecker wrote:
> > >  kernel/trace/trace_event_perf.c |   11 +++++++++--
> > >  1 files changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> > > index 0709e4f..69941f3 100644
> > > --- a/kernel/trace/trace_event_perf.c
> > > +++ b/kernel/trace/trace_event_perf.c
> > > @@ -15,7 +15,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
> > >  static char *perf_trace_buf;
> > >  static char *perf_trace_buf_nmi;
> > >  
> > > -typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
> > > +/*
> > > + * Force it to be aligned to unsigned long to avoid misaligned accesses
> > > + * suprises
> > > + */
> > > +typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
> > > +	perf_trace_t;
> > >  
> > 
> > wouldn't __aligned(8) be simpler?
> 
> 
> David and Tejun seemed to prefer to create the alignment on the
> type level rather than using an align.
> 
> I'm personally fine either way.

Also, if you need u64 alignment, shouldn't you use u64 instead of
unsigned long, the alignment requirement on those two might differ on
32bit machines.

