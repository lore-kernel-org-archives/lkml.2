Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1AGT4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:56:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1AGT4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:56:50 -0500
Date: Fri, 7 Jan 2011 20:49:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Dario Faggioli <raistlin@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
Message-ID: <20110107194913.GA29536@redhat.com>
References: <1293121303.3390.185.camel@Palantir> <20110107192809.05CFF40467@magilla.sf.frob.com> <20110107193547.GA28634@redhat.com> <20110107195016.2334940467@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107195016.2334940467@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Roland McGrath wrote:
>
> > Yes, I was worried about possible security issues too. But, it seems,
> > /proc/pid/task/tid/stat (do_task_stat) shows ->utime/stime anyway.
>
> This is constrained by ptrace_may_access(task, PTRACE_MODE_READ).

Well, ptrace_may_access() protects only get_wchan/eip/esp, but
not utime/stime.

> That's good, but it should be mentioned so that next year someone doesn't
> come back with a "there's no reason you shouldn't be able to" and go
> unchallenged.

Yes, agreed. The changelog should be improved.

Oleg.

