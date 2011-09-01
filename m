Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1IAMbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:31:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51914 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1IAMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:31:42 -0400
Date: Thu, 1 Sep 2011 14:31:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] nohz: Drop useless call in tick_nohz_start_idle()
Message-ID: <20110901123126.GA24650@somewhere.redhat.com>
References: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forget these patches. Peterz found that the 2nd one is buggy and
I need to refine the others changelog.

Thnaks.

On Thu, Jul 21, 2011 at 08:49:36PM +0200, Frederic Weisbecker wrote:
> The call to update_ts_time_stats() there is useless. All
> we need is to save the idle entry_time.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/time/tick-sched.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d5097c4..58e1a96 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -185,9 +185,6 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
>  	ktime_t now;
>  
>  	now = ktime_get();
> -
> -	update_ts_time_stats(cpu, ts, now, NULL);
> -
>  	ts->idle_entrytime = now;
>  	ts->idle_active = 1;
>  	sched_clock_idle_sleep_event();
> -- 
> 1.7.5.4
> 
