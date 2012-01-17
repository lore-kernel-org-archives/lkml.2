Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2AQNc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:32:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41126 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2AQNc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:32:27 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wBu39ZheO1YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=pLhl1wleAU47_697t_8A:9 a=kZYn86wrPLKQ2mrb9aYA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326807145.17534.26.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.3] tracing: Add header wrappers
 event_headers_start.h and event_headers_end.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 17 Jan 2012 08:32:25 -0500
In-Reply-To: <20120117095418.GG10397@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
	 <20120117095418.GG10397@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 10:54 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> Hm, i don't really like the extra complexity - this code 
> *really* does not need any more complexity ...

I agree.

> 
> How about the low-tech solution of adding some text between
> '/* */' markers to warns that these headers should not be 
> included in ordinary headers?

The problem is that they currently are. For example:

include/linux/interrupt.h

has one to add a tracepoint in __raise_softirq_irqoff()

Which is fine, as long as no other tracepoint header includes
linux/interrupt.h.

There's also one in module.h.

> 
> The build error will pinpoint the bug anyway, it's not like the 
> kernel can be broken in any dangerous way.

OK, I'll put away these patches. For now we can try to keep all
tracepoints out of header files as much as possible. They really
shouldn't be in static inline functions anyway, because they tend to
bloat the kernel, as we saw when it was included in slab_def.h

-- Steve


