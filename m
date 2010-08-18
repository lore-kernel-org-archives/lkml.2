Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0HRBHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:07:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0HRBHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:07:10 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=ToTR1L1PYWcA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=tb1a3BfQHp-Fk_apa-UA:9 a=NukC9b56XtqCYn8xzhQA:7 a=NnmdSIdNgigxRjCmLUw3pwM4o-4A:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100818005535.GH7362@dastard>
References: <20100817073725.GO10429@dastard>
	 <4C6A4A58.2030904@cn.fujitsu.com> <20100817115243.GE7362@dastard>
	 <1282050158.3268.1303.camel@gandalf.stny.rr.com>
	 <20100817224048.GF7362@dastard>
	 <1282086431.3268.1975.camel@gandalf.stny.rr.com>
	 <20100818005535.GH7362@dastard>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 21:07:07 -0400
Message-ID: <1282093627.3268.2168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 10:55 +1000, Dave Chinner wrote:
> On Tue, Aug 17, 2010 at 07:07:11PM -0400, Steven Rostedt wrote:

> > You mean because it uses synchronize_sched() it should be removed? Seems
> > that it was another kernel bug that caused the issue.
> 
> Right now I'm using the trace file for exactly what the docuemntation
> says it should be used for, but it hangs. You're saying that the
> interface is effectively redundant because there's a trace_pipe
> interface that shouldn't hang and I should use that instead.

trace_pipe consumes the data as trace does not.

> 
> Debug interfaces should be reliable in the face of common problems -
> a system burning a CPU in a tight loop is a pretty common problem.
> That leads to three options: either fix the hang, document the fact
> that the trace file is not reliable and that you should use other
> interfaces, or remove the interface altogether.

I could update the documentation to warn that the trace file uses the
common utility "synchronize_sched()" and that if you are debugging a
system that has a CPU out of commission, not to use it because,
synchronize_sched() will never return. If you need to debug this case,
then use trace_pipe which will consume all data, but is made for live
reads and does not use synchronize_sched().

But the tracer is used for more than just debugging. I use it for
analyzing system behavior, and not to debug anything, which I use the
trace file for all the time. I usually enable tracing, disable it, then
look at the trace file. For any live tracing, trace_pipe should be used.
If I had not documented that, I should go back and do so.

-- Steve


