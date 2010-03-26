Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0CZVpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:45:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61888 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0CZVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AIS6Gn+ioNl1fxpH2Lk5gm7R0yXEy5OuWRs8MwA3WGA0jok4s3nEoCXkWBimI/WI6u
         oC3ZVL3BKOnZN8uISUnEbdPTOF+pEXTJzXCW9ciNO8N7ZqqgXPGrrbWkTGDPBTeLhN9Q
         JlY/xhiqK1qYTgVF8uuYNSIbWR1IaOtTRxb0Y=
Date: Fri, 26 Mar 2010 22:45:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
Message-ID: <20100326214542.GF7166@nowhere>
References: <4BA9A885.9050105@cn.fujitsu.com> <1269415964.6530.25.camel@marge.simson.net> <1269418671.6465.6.camel@marge.simson.net> <4BAB1924.4060304@cn.fujitsu.com> <1269509241.8438.30.camel@marge.simson.net> <1269598293.6174.8.camel@marge.simson.net> <20100326172350.GC5188@nowhere> <1269630640.6331.18.camel@marge.simson.net> <20100326192712.GA7166@nowhere> <1269634924.6488.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269634924.6488.6.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 09:22:04PM +0100, Mike Galbraith wrote:
> [  427.931717]  <IRQ> 
> [  427.931717]  [<ffffffff811403f4>] __delay+0xa/0xc
> [  427.931717]  [<ffffffff81143e42>] do_raw_spin_lock+0xd2/0x13c
> [  427.931717]  [<ffffffff812dbc18>] _raw_spin_lock+0x34/0x3b
> [  427.931717]  [<ffffffff81026e03>] ? task_rq_lock+0x7c/0x97
> [  427.931717]  [<ffffffff8105f2b1>] ? trace_hardirqs_on+0xd/0xf
> [  427.931717]  [<ffffffff81026e03>] task_rq_lock+0x7c/0x97
> [  427.931717]  [<ffffffff8102d4a5>] try_to_wake_up+0x26/0x266
> [  427.931717]  [<ffffffff8102d704>] wake_up_process+0x10/0x12
> [  427.931717]  [<ffffffff810392f4>] wakeup_softirqd+0x2a/0x2c
> [  427.931717]  [<ffffffff81039771>] __do_softirq+0x21e/0x220
> [  427.931717]  [<ffffffff8104b6a0>] ? __task_pid_nr_ns+0x0/0xad
> [  427.931717]  [<ffffffff81002e0c>] call_softirq+0x1c/0x28
> [  427.931717]  [<ffffffff81004b73>] do_softirq+0x38/0x81
> [  427.931717]  [<ffffffff8103983a>] irq_exit+0x45/0x87
> [  427.931717]  [<ffffffff81016f86>] smp_apic_timer_interrupt+0x88/0x96
> [  427.931717]  [<ffffffff810028d3>] apic_timer_interrupt+0x13/0x20
> [  427.931717]  <EOI> 
> [  427.931717]  [<ffffffff8105eae6>] ? lock_acquire+0x108/0x117
> [  427.931717]  [<ffffffff8104b6a0>] ? __task_pid_nr_ns+0x0/0xad
> [  427.931717]  [<ffffffff810892f9>] ? perf_output_begin+0x0/0x24d
> [  427.931717]  [<ffffffff8104b6dc>] __task_pid_nr_ns+0x3c/0xad
> [  427.931717]  [<ffffffff8104b6a0>] ? __task_pid_nr_ns+0x0/0xad
> [  427.931717]  [<ffffffff8108668a>] perf_event_tid+0x26/0x28
> [  427.931717]  [<ffffffff8108960f>] perf_event_task_output+0x74/0x9f
> [  427.931717]  [<ffffffff81089675>] perf_event_task_ctx+0x3b/0x5b
> [  427.931717]  [<ffffffff810896e8>] perf_event_task_event+0x53/0xca
> [  427.931717]  [<ffffffff81089695>] ? perf_event_task_event+0x0/0xca
> [  427.931717]  [<ffffffff810897da>] perf_event_task+0x7b/0x86
> [  427.931717]  [<ffffffff8108a90e>] perf_event_fork+0x10/0x12



Aaah, I see now. That happens during a fork event!
So that looks indeed the right fix.

