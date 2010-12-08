Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0LHOG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:06:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0LHOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:06:26 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=FHf88goMU3QA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0LfQDv3ofC4lU6MEoUgA:9 a=rgnL-RFrKUEQg-kxg7sHyGZSv7cA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2 v2] tracing: Only trace sched_wakeup if it
 actually work something up
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1291810330.28378.6.camel@laptop>
References: <20101203040358.955427199@goodmis.org>
	 <20101203040822.473086528@goodmis.org>  <1291810330.28378.6.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Dec 2010 09:06:24 -0500
Message-ID: <1291817184.5015.866.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 13:12 +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-02 at 23:04 -0500, Steven Rostedt wrote:
> > Currently the tracepoint sched_wakeup traces the wakeup event even
> > if the wakeup failed to wake anything up. This is quite stupid
> > but it happens because we did not want to add a conditional
> > to the core kernel code that would just slow down the wakeup events.
> > 
> Its actually quite useful at times, so no, I don't much like this.

OK, I'll remove this patch. This is why I kept it at the end of the
queue.

But I'm curious. Linus ripped into me about the uselessness of this
event when success was not true. What use do you see of this tracepoint
when a wake up does not happen? I, personally, just filter these out.

-- Steve


