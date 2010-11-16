Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0KPU2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:28:52 -0500
Received: from mail.openrapids.net ([64.15.138.104]:33664 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755199Ab0KPU2t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:28:49 -0500
Date: Tue, 16 Nov 2010 15:28:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Subject: Re: Benchmarks of kernel tracing options (ftrace, ktrace, lttng
	and perf)
Message-ID: <20101116202844.GA1016@Krystal>
References: <AANLkTim8c+FLo11XJbTmTjiuucn-9UJD0Vui=fvUgCd+@mail.gmail.com> <AANLkTikd6sawwJeBm76QLeowXj0GBAf=wpRVgG8x5MOp@mail.gmail.com> <AANLkTi=Dw-dxkUgYLZYBKb5sGYcdGcpS0OH_fEHW51Jr@mail.gmail.com> <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:21:22 up 55 days, 23 min,  7 users,  load average: 0.09, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Sharp (dhsharp@google.com) wrote:
[...]
> Results for amount of time to execute a tracepoint (includes previous results):
> ktrace: 200ns   (old)
> ftrace: 224ns   (old, w/ handcoded tracepoint, not syscall tracing)
> lttng: 449ns    (new)
> perf: 1047ns    (new)
> 
> Also interesting:
> ftrace: 587ns   (old, w/ syscall tracing)
> This just shows that syscall tracing is much slower than a normal tracepoint.

As I pointed out in my email a few weeks ago, the LTTng comparison is simply
bogus because the "syscall tracing" thread-flag is active, which calls into
syscall tracing, after saving all registers, from entry_*.S, both at syscall
entry and exit.

I did benchmarks using Steven's ring_buffer_benchmark kernel module, which calls
tracing in a loop, for both Ftrace and the Generic Ring Buffer (which is derived
from LTTng). The results are:

Intel Xeon 2.0GHz

ftrace:  103 ns/entry (no reader)
lttng:    83 ns/entry (no reader) (with the generic ring buffer library)

So, given that even after I pointed out that the results above were bogus,
people took the numbers for granted, and given that David seems busy on other
things, I thought I should set records straight.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
