Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1AGTuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:50:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab1AGTui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:50:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Dario Faggioli <raistlin@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
In-Reply-To: Oleg Nesterov's message of  Friday, 7 January 2011 20:35:47 +0100 <20110107193547.GA28634@redhat.com>
References: <1293121303.3390.185.camel@Palantir>
	<20110107192809.05CFF40467@magilla.sf.frob.com>
	<20110107193547.GA28634@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20110107195016.2334940467@magilla.sf.frob.com>
Date: Fri,  7 Jan 2011 11:50:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I was worried about possible security issues too. But, it seems,
> /proc/pid/task/tid/stat (do_task_stat) shows ->utime/stime anyway.

This is constrained by ptrace_may_access(task, PTRACE_MODE_READ).

> And /proc/schedstat shows sum_exec_runtime.

This probably should be constrained in exactly the same ways as .../stat is.

I think the constraints on /proc/.../stat reflect the most considered
judgement of the security folks.  I suspect that the lack of constraint on
/proc/.../schedstat reflects the scheduler folks just having failed to
consider the same issues.  IMHO all access to the equivalent kinds of
information should have the same security constraints.

> No, the suggested change doesn't go that far, afaics. It only modifies
> check_clock: this affects clock_getres and clock_set (which does nothing),
> and posix_cpu_clock_get: affects clock_gettime().

That's good, but it should be mentioned so that next year someone doesn't
come back with a "there's no reason you shouldn't be able to" and go
unchallenged.


Thanks,
Roland
