Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1HFO5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 10:57:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1HFO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 10:57:03 -0400
Date: Sat, 6 Aug 2011 16:56:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
Message-ID: <20110806145655.GB29058@somewhere>
References: <20110805205921.909038487@goodmis.org>
 <20110805212409.GA21114@elte.hu>
 <20110806004342.GG22164@somewhere>
 <20110806064847.GB13220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806064847.GB13220@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 08:48:47AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Aug 05, 2011 at 11:24:09PM +0200, Ingo Molnar wrote:
> > > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > By keeping the code separate from perf, made the transition from 
> > > > trace-cmd to tools much easier. I've wasted too many days trying to 
> > > > get other ways working, and I don't want to rewrite perf to do so.
> > > 
> > > But we want to move tools together, not further apart. Every code 
> > > activity i see from you is trying to tear apart instrumentation 
> > > tooling - while previously you agreed that it should be unified. So 
> > > why not do tools/perf/lib/ as you agreed before?
> > > 
> > > I'm really not interested in seeing the libdrm/libdri mess repeated. 
> > > Libraries have their uses when there's some very important external 
> > > interface, but here it's actively harmful as it complicates and 
> > > hardcodes APIs into ABIs that are clearly not finished yet.
> > > 
> > > Really, lets not be stupid here.
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > The trace events format is a general interface that not only perf 
> > and trace-cmd use but also powertop and pytimechart, and may be 
> > others?
> > 
> > And given the breakage we had with powertop, for example, that 
> > broke because it was relying on an ad-hoc static layout of the 
> > trace event, or pytimechart that relies(ed?) on the event string 
> > output, I think that library is needed outside perf.
> 
> That is why i suggested libperf.so - this will handle the cases you 
> mention, plus any future case - while still allow more flexible code 
> sharing between libperf and the perf tools themselves.

But what would you want inside libperf.o, further the trace event
library?
