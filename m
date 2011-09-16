Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1IPVhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:37:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1IPVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:37:40 -0400
X-Authority-Analysis: v=1.1 cv=MgN7/KJv0EmO5CJGH57r3ABwexVA6M4dLJdFirx4b8Y= c=1 sm=0 a=NvagiCqJaCEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=xS5jSEWui3eyScSDnKYA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] ftrace: use a global counter for the global clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <66899.1316207693@turing-police.cc.vt.edu>
References: <1316163765.10174.8.camel@twins>
	 <1316175506.26295.36.camel@gandalf.stny.rr.com>
	 <66899.1316207693@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 16 Sep 2011 17:37:36 -0400
Message-ID: <1316209057.26295.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 17:14 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Sep 2011 08:18:26 EDT, Steven Rostedt said:
> 
> > +	return atomic64_add_return(1, &trace_counter);
> 
> Given that the usefulness of this is probably directly proportional to the
> number of cores on the box, is this subject to cache line ping-ponging on
> systems with many cores?

It will cause hickups, but shouldn't really change much of the ordering.
If anything, it may synchronize more.

> 
> > When debugging tight race conditions, it can be helpful to have a
> > synchronized tracing method. Although in most cases the global clock
> > provides this functionality, if timings is not the issue, it is more
> > comforting to know that the order of events really happened in a precise
> > order.
> 
> One wonders if the overhead can end up being enough to change the
> ordering, and possibly cause a heisenbug (most likely if the race condition
> involves one CPU doing something we're tracing, and another CPU doing
> something we are *not* tracing)...

My use of logdev synchronized traces like this. But it actually caught a
lot of race conditions. Really, it's about catching the ordering of what
happens in a race condition, and having the tracer actually introduce
synchronization helped in analysis. But true, as a heisenbug effect,
enabling this tracer may make the bug go away.

> 
> If that's considered not an issue, feel free to stick this on it:
> Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Thanks, and yes, it is not too much of a concern. It just adds another
option developers can use. Thus, if you are worried about cache line
bouncing, just use the global or local clock, otherwise use the counter.
Which I plan on documenting this side effect.

-- Steve


