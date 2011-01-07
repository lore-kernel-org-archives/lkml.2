Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1AGTn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:43:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1AGTnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:43:24 -0500
Date: Fri, 7 Jan 2011 20:35:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Dario Faggioli <raistlin@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
Message-ID: <20110107193547.GA28634@redhat.com>
References: <1293121303.3390.185.camel@Palantir> <20110107192809.05CFF40467@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107192809.05CFF40467@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Roland McGrath wrote:
>
> This can certainly be enhanced, but it opens some cans of worms about the
> security question.  It is probably still considered an unsafe information
> leak to let every process examine every other process's thread clocks.

Yes, I was worried about possible security issues too. But, it seems,
/proc/pid/task/tid/stat (do_task_stat) shows ->utime/stime anyway.
And /proc/schedstat shows sum_exec_runtime.

> I'll leave that judgement to security folks.

Agreed.

> As well as the information leak, it is most certainly a DoS attack vector
> to allow one process to set CPU timers an another process or its threads.

No, the suggested change doesn't go that far, afaics. It only modifies
check_clock: this affects clock_getres and clock_set (which does nothing),
and posix_cpu_clock_get: affects clock_gettime().

Oleg.

