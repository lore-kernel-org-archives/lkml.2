Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0ESOrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:47:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0ESOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:47:22 -0400
X-Authority-Analysis: v=1.1 cv=XlIRUSWzFvHiorqRgyN8fup7OiOLcGcwhtEWqPJTlSs= c=1 sm=0 a=1hn_8qm_4N4A:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=_U1WukpWr3RG3h7lR0IA:9 a=opzD-cgUcL2ImimPCqkA:7 a=Q17-Bh8gEOmp0VI_ZhH571syKUoA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1274255882.5605.10216.camel@twins>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 10:47:19 -0400
Message-ID: <1274280439.26328.770.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 09:58 +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 09:21 +0200, Frederic Weisbecker wrote:
> 
> > I'm still not sure what you mean here by this multiplexing. Is
> > this about per cpu multiplexing?
> 
> Suppose there's two events attached to the same tracepoint. Will you
> write the tracepoint twice and risk different data in each, or will you
> do it once and copy it into each buffer?

Is this because the same function deals with the same tracepoint, and
has difficulty in knowing which event it is dealing with?

Note, the shrinking of the TRACE_EVENT() code that I pushed (and I'm
hoping makes it to 35 since it lays the ground work for lots of features
on top of TRACE_EVENT()), allows you to pass private data to each probe
registered to the tracepoint. Letting the same function handle two
different activities, or different tracepoints.

> 
> > There is another problem. We need something like
> > perf_output_discard() in case the filter reject the event (which
> > must be filled for this check to happen).
> 
> Yeah, I utterly hate that, I opted to let anything with a filter take
> the slow path. Not only would I have to add a discard, but I'd have to
> decrement the counter as well, which is a big no-no.

Hmm, this would impact performance on system wide recording of events
that are filtered. One would think adding a filter would speed things
up, not slow it down.

-- Steve


