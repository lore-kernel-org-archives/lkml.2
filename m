Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1EYXla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:41:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1EYXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:41:29 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=oOzZnGprw0sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KqJEFJB4XiZQm5iJc7kA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] ftrace: Add internal recursive checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1105260050250.3078@ionos>
References: <1306348063.1465.116.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1105252054270.3078@ionos>
	 <1306355009.1465.119.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1105260050250.3078@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 19:41:26 -0400
Message-ID: <1306366886.1465.124.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 00:54 +0200, Thomas Gleixner wrote:
> On Wed, 25 May 2011, Steven Rostedt wrote:

> > Any user of the function tracer (callbacks) may need to do the same
> > thing, because the callbacks could be called without going though the
> > list lookup and may need their own bit set.
> 
> Errm, what means _MAY_? There are no users outside of kernel/trace/
> for this right now. Are you saying that you forgot to update some code
> or is this about random out of tree users?

Actually, I was thinking about perf, not some random out of tree user.
But if this is needed, I hate to have to move the code then. It's not
like it's modifying some internal to ftrace variable. It is modifying a
variable in the task_struct. If there are other users that need it. Why
not expose it in a core header? And it's not like ftrace.h is a bad
location for this. ftrace.h is in fact made for function tracing.

This would not even work for out of tree users, as any bit they chose,
could someday conflict with an internal user.

-- Steve


