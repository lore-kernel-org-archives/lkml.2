Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2IJOnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:43:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2IJOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:43:21 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=JBLNcV8zRgkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=B2NTZjWQ9qwA:10 a=2_GR34GhAEWsWnWph5IA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347288200.10751.17.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] perf: Enable function tracing for perf core
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 10 Sep 2012 10:43:20 -0400
In-Reply-To: <20120908130646.GA2122@somewhere.redhat.com>
References: <20120908115515.211175517@goodmis.org>
	 <20120908115640.032328533@goodmis.org>
	 <20120908130646.GA2122@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 15:06 +0200, Frederic Weisbecker wrote:
> On Sat, Sep 08, 2012 at 07:55:16AM -0400, Steven Rostedt wrote:
> > According to Steven R. there is no reason left to not support
> > function tracing for the perf core. This makes it easier to debug
> > perf.
> > 
> > Don't remove -pg for the x86 and generic perf core.
> 
> Actually, perf can use function tracing. A good reason for disabling
> function tracing in perf is to avoid the overhead of recursive function
> tracing, even though we are protected against tracing re-entrancy, this
> still result in some overhead.

Yes, but perf shouldn't do a full function trace. It should be filtering
on what functions it wants to trace, and if it needs to, we can easily
make it not trace its own functions.

I've been thinking about adding function tracing into the trace
directory. As there's been several times I wanted it. The only files
that really shouldn't be traced in there is ftrace.c, trace_function.c
and trace_function_graph.c. The rest I believe is fair game.

-- Steve


