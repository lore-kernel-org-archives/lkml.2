Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab0HQXHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:07:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0HQXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:07:14 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=ToTR1L1PYWcA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=oIecyIgh3kb4mvnnsTQA:9 a=JgZuFtUTj-2NDhElnGUA:7 a=ct0Cr_XzCwuKr2GSFiKUk189bQcA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100817224048.GF7362@dastard>
References: <20100817073725.GO10429@dastard>
	 <4C6A4A58.2030904@cn.fujitsu.com> <20100817115243.GE7362@dastard>
	 <1282050158.3268.1303.camel@gandalf.stny.rr.com>
	 <20100817224048.GF7362@dastard>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 19:07:11 -0400
Message-ID: <1282086431.3268.1975.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 08:40 +1000, Dave Chinner wrote:

> > When the systems locks up, I assume you want to see why? The trace_pipe
> > should show that without locking the system.
> 
> Exactly.

So it did work?

> 
> > You could also try downloading trace-cmd and running the tracer with
> > that. That will save all traces to a file while running the trace.
> 
> I don't have tens of GB available to store all the traces that an
> xfstests test run generates. In general, I don't need the traces,
> either, and when  I do the problem is usually in the current ring
> buffer, which is why I typically dump the events after the fact.

Note, you can also use: trace-cmd extract

which will extract the data from the ring buffer after the fact.

The resulting file ("trace.dat" by default) would allow you to read it
via kernelshark, or use the trace-cmd filters on it as well.

> 
> If the trace file cannot be made to handle this type of use
> robustly, then perhaps it should be removed...

You mean because it uses synchronize_sched() it should be removed? Seems
that it was another kernel bug that caused the issue.

I find the trace file nice to use, to look at a file over and over
again. I could just cat trace_pipe into another file and look at that
too I suppose. But I don't find this reason as rational to remove it.

-- Steve


