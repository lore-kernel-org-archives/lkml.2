Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1JJK7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:59:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60680 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1JJK7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:59:00 -0400
Subject: Re: [PATCH 0/3][RFC] trace_printk() using percpu buffers
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20111008170227.792806635@goodmis.org>
References: <20111008170227.792806635@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 13:04:57 +0200
Message-ID: <1318244697.14400.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-08 at 13:02 -0400, Steven Rostedt wrote:
> 
> Peter,
> 
> You had issues with the previous version of my trace_printk() code.
> I rewrote it to do the following.
> 
> By default, it still uses the single buffer protected by a spinlock
> and an atomic (for NMIs). The NMI case can cause dropped prints if
> the NMI happens while a trace_printk() is processing.

Why bother keeping that?

> When trace_printk_percpu is enabled, either via the trace options or
> the kernel command line, then two sets of percpu buffers are made,
> one for normal and irqs (interrupts are still disabled), and the other
> is for NMIs. These can be added or removed at anytime.

So why not allocate 4, one for {task, softirq, irq, NMI} resp, then all
you need to do is disable preemption.

depending on tracing/options/trace_printk ?

> The last patch adds a CONFIG_TRACE_PRINTK_PERCPU that makes trace_printk()
> permanently use two sets of per_cpu buffers, and these can not be
> removed. This will give the least amount of overhead for trace_printk()
> with the sacrifice of memory overhead. This is an option I could imagine
> you would just set and forget about.

Is that one dereference really that expensive?

