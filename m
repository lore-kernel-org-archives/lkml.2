Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0IKRkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 13:40:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54174 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0IKRkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 13:40:36 -0400
Message-Id: <20100911173732.551632040@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 11 Sep 2010 13:37:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC patch 0/2] sched: dynamically adapt granularity with nr_running
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 11 Sep 2010 17:40:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the minimum granularity is a double-edged sword: if we set it to a too
small value, then the scheduler will preempt tasks too often. If it is too
large, then the "latency" period can grow very large as the number of running
tasks increases.

The first patch leaves the same scheduling granularity when there are few tasks
on the system (3 or less), but dynamically adapts (shrinks) the sched
granularity when there are more. At a ceiling value of 8 running tasks (this
choice is arbitrary), it grows the latency rather than shrinking granularity
further to ensure we don't end up calling the scheduler too often.

The second patch ensures that awakened sleeping tasks don't get affected by
shrinked minimum granularity.

Comments are welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
