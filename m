Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0ESQ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:27:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0ESQ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:27:16 -0400
X-Authority-Analysis: v=1.1 cv=XlIRUSWzFvHiorqRgyN8fup7OiOLcGcwhtEWqPJTlSs= c=1 sm=0 a=1hn_8qm_4N4A:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=29wpC8YMVHWIUfTSIyEA:9 a=Ng3c-Od_cgOWiuSLsL1NVZ3USWUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <1274285709.5605.11265.camel@twins>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
	 <1274280439.26328.770.camel@gandalf.stny.rr.com>
	 <1274281506.5605.11111.camel@twins>
	 <1274283492.26328.779.camel@gandalf.stny.rr.com>
	 <1274284201.5605.11212.camel@twins>
	 <1274285293.26328.788.camel@gandalf.stny.rr.com>
	 <1274285709.5605.11265.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 12:27:14 -0400
Message-ID: <1274286434.26328.800.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 18:15 +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 12:08 -0400, Steven Rostedt wrote:
> > > Now suppose you have multiple active consumers of the tracepoint, either
> > > you do the evaluation once and copy that around, or you do it multiple
> > > times and end up with different results.
> > 
> > OK, this is where I'm getting a bit lost. The "multiple active
> > consumers". Is this multiple instances of perf? Or perf doing multiple
> > things with that event using different buffers? 
> 
> Multiple perf events of the same tracepoint, basically what you would en
> up with if you were to allow multiple buffers.
> 
> Say task A and B both sample C's sched:sched_wakeup events. Then the
> tracepoint will have two active perf_events hanging from it and we need
> to fill two buffers.

OK, so I would let them evaluate separately. If they do have two
different results, then that's fine, because the view of an event could
possible be different. The &bar may change in the two instances, but how
much does that matter? Which version of &bar is correct anyway?

How do you handle the multiple readers then? The call to record the
event copies to each buffer that is registered for that event?

If more than one buffer is attached to an event, you could also work to
directly write to one, and then copy directly from that buffer to the
others.

-- Steve



