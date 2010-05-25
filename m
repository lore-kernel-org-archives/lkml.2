Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0EYTqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:46:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0EYTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:46:10 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=mI6YO6ZdSLUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=MycSxdv06LgxrQ6lgxYA:9 a=T2SdPZdQcpui6ZRkLZn9Bn-ZgHUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Tracing configuration review
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274815906.9757.83.camel@cndougla-ubuntu>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 25 May 2010 15:46:08 -0400
Message-ID: <1274816768.22648.220.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 15:31 -0400, Chase Douglas wrote:
> Hi all,
> 
> I'm going through our Ubuntu kernel configuration for our next release
> to ensure we have all the trace options enabled that may be useful. I
> have a few questions about what tracer options we should have enabled.
> 
> Our guiding principle in regards to these options is: if an option can
> be turned on and has no performance impact unless explicitly enabled on
> the kernel command line or at runtime, we are happy to enable it.
> Secondarily, we don't want to enable options that are headed for
> deprecation.
> 
> The following options are what I am looking to set for our x86
> configurations. I've only included those that I am not 100% sure of.
> Comments are what I could gather from documentation and Kconfig, but
> they may not be accurate:
> 
> # CONFIG_IRQSOFF_TRACER is not set (performance impact by default)

Correct, keep that off.

> # CONFIG_SYSPROF_TRACER is not set (don't know much about this)

Neither do I ;-)


> # CONFIG_SCHED_TRACER is not set (headed for deprecation?)

Although it is headed for deprecation, I think it still gets set by
other tracers, since it has the code to initiate the comm reader.

> CONFIG_FTRACE_SYSCALLS=y (no performance impact by default)

Correct

> CONFIG_BOOT_TRACER=y (no performance impact by default)

But this tracer is pretty useless. It gives no more information than
debug_initcalls.

> CONFIG_KSYM_TRACER=y (no performance impact by default)

Yep

> # CONFIG_STACK_TRACER is not set (Kconfig says N if unsure)

I would set this if you already have the function tracer. It gives no
more overhead than that, and it is very useful.

> # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)

Don't know.

> CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)
> 
> Lastly, what options are safe for performance when
> HAVE_DYNAMIC_FTRACE=n, like on our ARM kernels. It is not clear to me
> through what's in Documentation/trace/* and the Kconfig entries what
> options could cause a performance decrease due to the inability to
> dynamically enable and disable tracing at runtime.

HAVE_DYNAMIC_FTRACE affects the function tracer. If you do not have
that, then do not enable FUNCTION_TRACER or anything that depends on it.

Also note, FUNCTION_TRACER depends on FRAME_POINTERS. Your millage may
vary with that. If you already have FRAME_POINTERS on, and the arch
supports DYNAMIC_FTRACE, then its fine to have FUNCTION_TRACER and all
those that are built on top (STACK_TRACER, FUNCTION_GRAPH, etc)

-- Steve


