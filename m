Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0J2EiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:38:12 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46847 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751148Ab0J2EiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:38:05 -0400
Date: Fri, 29 Oct 2010 00:37:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Benchmarks of kernel tracing options (ftrace, ktrace, lttng
	and perf)
Message-ID: <20101029043758.GA32614@Krystal>
References: <AANLkTim8c+FLo11XJbTmTjiuucn-9UJD0Vui=fvUgCd+@mail.gmail.com> <AANLkTikd6sawwJeBm76QLeowXj0GBAf=wpRVgG8x5MOp@mail.gmail.com> <AANLkTi=Dw-dxkUgYLZYBKb5sGYcdGcpS0OH_fEHW51Jr@mail.gmail.com> <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com> <20101028192704.GA26131@Krystal> <AANLkTimPTw4M7iSOna47mT06D7BvPx4__0qm71pKF62G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPTw4M7iSOna47mT06D7BvPx4__0qm71pKF62G@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 00:26:24 up 36 days,  8:28,  1 user,  load average: 0.03, 0.09,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Rubin (mrubin@google.com) wrote:
> On Thu, Oct 28, 2010 at 12:27 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > * David Sharp (dhsharp@google.com) wrote:
> > Hrm, not quite fair actually. LTTng enables a thread flag that causes
> > syscall_trace to be called on sycall entry/exit by default. Please try with the
> > following patch to remove the extra syscall overhead.
> 
> We started this thread is an attempt to get the ball rolling on
> keeping track of these metrics. They seem important for both Google
> and Linux as a whole. We published all our work and benchmarks with
> hopes that the owners could comment and also run the tests themselves.
> 
> Matthieu it might make more sense for you to find the" fair" setup and
> publish that, than take the extra time to go back and forth with
> David. Once you have the config that best represents what users will
> see and you have numbers to go with it, we can then run it in our
> environment. I worry you will be forced to send us patch and patch and
> patch and we won't have the resources to do a good job in responding
> to them. Which is not fair to you.

Nah, it's really a matter of fine-tuning really. I already performed these
benchmarks, have published the results, and know what to expect, so I figured
out quickly that something was wrong with your setup. Disabling the extra
syscall tracing is the only detail I see that is missing for fair comparison of
LTTng with your setup.

For the "fair" setup to compare ring buffers, I would personally tend to say
that going through a system call might not be the way I would benchmark the ring
buffer per se, but I must admit that the benchmark you are doing is very useful
for evaluation of system call entry/exit tracing. On this particular aspect, I
have always admitted that lttng is not super-fast, but it actually takes the
same overhead as the Linux kernel syscall tracing has today. But given it is
always enabled when lttng tracing runs, you happened to add this overhead to the
lttng ring buffer inappropriately.

I'm willing to help David with the setup, and I'm sure it won't take long. By
the way, I'm currently porting lttng to the new Generic Ring Buffer Library,
which might be even slightly faster than the current lttng code (and faster than
ftrace with the ring buffer benchmark Steven wrote). So when I'm done porting
lttng to it, it might be worthwhile to benchmark the Generic Ring Buffer too.

Thank you,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
