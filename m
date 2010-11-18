Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0KRNGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:06:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34773 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab0KRNGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:06:39 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=AvpIYEOr2ZAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=kMQ7HcHWZslwXH8gQD4A:9 a=kEsxUruThz5qdmqYLzweFItIjp8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
 directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101118125307.GB5344@nowhere>
References: <20101118035803.453609353@goodmis.org>
	 <1290076866.2109.1305.camel@laptop>  <20101118125307.GB5344@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 08:06:36 -0500
Message-ID: <1290085596.30543.112.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 13:53 +0100, Frederic Weisbecker wrote:
> n other solution, which have been talking with Thomas yesterday, would be
> to allow having a single fd for several perf_events at once. That would
> solve some problems when you have hundreds of events opened (think about
> wide tracing, or use of all individual syscalls).

I would highly recommend this. One type of tracing I do all the time is
to enable all events (over 600). I don't think that is currently
possible with trace and/or perf.

Ftrace has no issue simple because it just stores all the events into a
single buffer (per cpu though). It does not care if there's one event or
1000.

You need to figure out how to do this as well with the function tracer.
Of course you can just have it as a single event and filter as needed.

-- Steve




