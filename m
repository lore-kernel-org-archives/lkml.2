Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0KRKlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:41:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:35140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0KRKlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:41:06 -0500
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
 directory
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101118035803.453609353@goodmis.org>
References: <20101118035803.453609353@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 11:41:06 +0100
Message-ID: <1290076866.2109.1305.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 22:58 -0500, Steven Rostedt wrote:
> For example, I added a trace_printk() in kernel/sched.c at line 2180
> and it creates:
> 
> # ls /debug/tracing/events/printk/kernel/sched.c/2180/
> enable  format
> 
> The format is the printk format:
> 
> # cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
> "migrate task %s:%d"

*groan*, so you're creating a tracepoint per instance?

That's going to be massive pain for perf.. I really don't see the point
in splitting all that out.
