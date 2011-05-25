Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1EYXrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:47:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1EYXrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:47:23 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=oOzZnGprw0sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=xor9eh15-SmmYCskkikA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <1306366886.1465.124.camel@gandalf.stny.rr.com>
References: <1306348063.1465.116.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1105252054270.3078@ionos>
	 <1306355009.1465.119.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1105260050250.3078@ionos>
	 <1306366886.1465.124.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 19:47:21 -0400
Message-ID: <1306367241.1465.127.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 19:41 -0400, Steven Rostedt wrote:
> On Thu, 2011-05-26 at 00:54 +0200, Thomas Gleixner wrote:
> > On Wed, 25 May 2011, Steven Rostedt wrote:

> > Errm, what means _MAY_? There are no users outside of kernel/trace/
> > for this right now. Are you saying that you forgot to update some code
> > or is this about random out of tree users?
> 
> Actually, I was thinking about perf, not some random out of tree user.
> But if this is needed, I hate to have to move the code then. It's not
> like it's modifying some internal to ftrace variable. It is modifying a
> variable in the task_struct. If there are other users that need it. Why
> not expose it in a core header? And it's not like ftrace.h is a bad
> location for this. ftrace.h is in fact made for function tracing.

Thinking about this a little more. I think I will put this in
kernel/trace/trace.h. Not for the reasons you give, but because the next
change in this area (for the next merge window) I want to have mcount do
the work, and then we only need one recursive bit set, and it will
handle function recursion by all users, and then we don't need to worry
about recursions due to the function tracer anymore :)

-- Steve


