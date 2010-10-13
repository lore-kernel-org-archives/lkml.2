Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0JMXul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:50:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab0JMXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:50:40 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=T9ZRXmIXaAQA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oVmpcOy8t3OHlJR9xPQA:9 a=JDjlX5MVVa8Gvyi4TdN-gsfs3dQA:4 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Benchmarks of kernel tracing options (ftrace and ktrace)
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com>
	 <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
	 <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 19:50:30 -0400
Message-ID: <1287013830.3673.224.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 16:19 -0700, David Sharp wrote:
> Google uses kernel tracing aggressively in the its data centers. We

Thanks!

> wrote our own kernel tracer, ktrace. However ftrace, perf and LTTng
> all have a better feature set than ktrace, so we are abandoning that
> code.

Cool!

> 
> We see several implementations of tracing aimed at the mainline kernel
> and wanted a fair comparison of each of them to make sure they will
> not significantly impact performance. A tracing toolkit that is too
> expensive is not usable in our environment.
> 

[ snip for now (I'm traveling) ]

> This first set of benchmark results compares ftrace to ktrace. The
> numbers below are the "on" result minus the "off" result for each
> configuration.
> 
> ktrace: 200ns  (tracepoint: kernel_getuid)
> ftrace: 224ns   (tracepoint: timer:sys_getuid)
> ftrace: 587ns   (tracepoint: syscalls:sys_enter_getuid)


> The last result shows that the syscall tracing is about twice as
> expensive as a normal tracepoint, which is interesting.

Argh, the syscall tracing has a lot of overhead. There is only one
tracepoint that is hooked into the ptrace code, and will save all
registers before calling the functions. It enables tracing on all
syscalls and there's a table that decides whether or not to trace the
syscall.

So I'm not surprised with the result that the syscall trace point is so
slow (note, perf uses the same infrastructure).

-- Steve


