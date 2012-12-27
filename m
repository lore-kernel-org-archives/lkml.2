Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2L0JwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:52:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44509 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2L0JwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:52:13 -0500
X-AuditID: 9c930179-b7becae000000e51-a8-50dc1a4b824c
From: Namhyung Kim <namhyung@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Steven Rostedt <rostedt@goodmis.org>,
        Fredereic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] tracing: Use sched_clock_cpu for trace_clock_global
References: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
	<1356576585-28782-2-git-send-email-namhyung@kernel.org>
Date: Thu, 27 Dec 2012 18:52:10 +0900
In-Reply-To: <1356576585-28782-2-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Thu, 27 Dec 2012 11:49:45 +0900")
Message-ID: <87wqw3rfed.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012 11:49:45 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> For systems have unstable sched_clock, all cpu_clock() does is enable/
> disable local irq during call to sched_clock().  And for stable systems

Oops, I meant s/sched_clock/scheck_clock_cpu/.

Thanks,
Namhyung


> they are same.
>
> As in trace_clock_global(), we already does it for local irq, calling
> sched_clock_cpu() directly would be appropriate.
>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Fredereic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_clock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index 394783531cbb..795f077978a8 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -86,7 +86,7 @@ u64 notrace trace_clock_global(void)
>  	local_irq_save(flags);
>  
>  	this_cpu = raw_smp_processor_id();
> -	now = cpu_clock(this_cpu);
> +	now = sched_clock_cpu(this_cpu);
>  	/*
>  	 * If in an NMI context then dont risk lockups and return the
>  	 * cpu_clock() time:
