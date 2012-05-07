Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2EGNNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:13:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34466 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2EGNNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:13:51 -0400
Subject: Re: [PATCH] sched: Removed redundant set_current_state in "yield"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frank Rowand <frank.rowand@am.sony.com>,
        Paul Turner <pjt@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1334072733-2614-1-git-send-email-sasikanth.v19@gmail.com>
References: <1334072733-2614-1-git-send-email-sasikanth.v19@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 15:13:36 +0200
Message-ID: <1336396416.27020.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 21:15 +0530, Sasikantha babu wrote:
> Removed redundant setting current task state to TASK_RUNNING.
> 
> During yield process will always remains in TASK_RUNNING state. 

Uhm, no, if you call yield() with !TASK_RUNNING you'll block and need a
proper wakeup. That is, you can in fact abuse yield() as schedule().

> Process state of  yielded process will not change from TASK_RUNNING, so it does not 
> make sense setting the process state again to TASK_RUNNING (TASK_RUNNING -> TASK_RUNNING).

No real objections, but have you tested/verified that all users are
indeed unaffected by this change?

> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
> ---
>  kernel/sched/core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4603b9d..c2a357d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4624,7 +4624,6 @@ EXPORT_SYMBOL(__cond_resched_softirq);
>   */
>  void __sched yield(void)
>  {
> -	set_current_state(TASK_RUNNING);
>  	sys_sched_yield();
>  }
>  EXPORT_SYMBOL(yield);



