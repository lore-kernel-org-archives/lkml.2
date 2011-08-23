Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1HWQu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:50:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62590 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1HWQut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:50:49 -0400
Date: Tue, 23 Aug 2011 18:50:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] nohz: Drop useless call in tick_nohz_start_idle()
Message-ID: <20110823165041.GB14903@somewhere.redhat.com>
References: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? No problem with these three patches?

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
