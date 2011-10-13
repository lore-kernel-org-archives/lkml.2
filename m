Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1JMNzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:55:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1JMNzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:55:46 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=NFX316_vVeIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=79Vv4NO_AFKKW34PXgkA:9 a=kV5x2fw3hP8hzNqUX3MA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318514142.12224.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 13 Oct 2011 09:55:42 -0400
In-Reply-To: <20111013085936.GA13046@elte.hu>
References: <20111011152026.701326733@goodmis.org>
	 <20111012081629.GA25086@elte.hu>
	 <1318418515.13262.21.camel@gandalf.stny.rr.com>
	 <1318425974.13262.26.camel@gandalf.stny.rr.com>
	 <20111012162320.GA31857@elte.hu> <20111013085936.GA13046@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Peter Zijlstra ]

On Thu, 2011-10-13 at 10:59 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Tests are also looking good so far.
> 
> there's a cross-build failure on the m32r architecture:

Hmm, I don't have a m32r cross compiler in my arsenal.

 
> 
> /home/mingo/tip/kernel/trace/trace_clock.c:117: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'trace_counter'
> /home/mingo/tip/kernel/trace/trace_clock.c: In function 'trace_clock_counter':
> /home/mingo/tip/kernel/trace/trace_clock.c:126: error: implicit declaration of function 'atomic64_add_return'
> /home/mingo/tip/kernel/trace/trace_clock.c:126: error: 'trace_counter' undeclared (first use in this function)
> /home/mingo/tip/kernel/trace/trace_clock.c:126: error: (Each undeclared identifier is reported only once
> /home/mingo/tip/kernel/trace/trace_clock.c:126: error: for each function it appears in.)

At that line there's:

static atomic64_t trace_counter;

I take it that m32r does not define an atomic64_t. Does this mean that
we can not use it? This code was taken from Peter, as it stated in the
commit log:

commit 6249687f76b69cc0b2ad34636f4a18d693ef3262
tracing: Add a counter clock for those that do not trust clocks

[...]

    The trace_clock_counter() is added from the attempt by Peter Zijlstra
    trying to convert the trace_clock_global() to it. I took Peter's counter
    code and made trace_clock_counter() instead, and added it to the choice
    of clocks. Just echo counter > /debug/tracing/trace_clock to activate
    it.

I think the fix to this is to add:

CONFIG_GENERIC_ATOMIC64 to m32r.

-- Steve


