Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1BAUeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:34:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37070 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1BAUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:34:12 -0500
Subject: Re: [patch 04/28] posix-timers: Introduce clock_posix_cpu
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134417.841974553@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134417.841974553@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 12:34:04 -0800
Message-ID: <1296592444.3336.21.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-introduce-local-posix-cpu-clockid.patch)
> The CLOCK_DISPATCH() macro is a horrible magic. We call common
> functions if a function pointer is not set. That's just backwards.
> 
> To support dynamic file decriptor based clocks we need to cleanup that
> dispatch logic.
> 
> Create a k_clock struct clock_posix_cpu which has all the
> posix-cpu-timer functions filled in. After the cleanup the functions
> can be made static.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  include/linux/posix-timers.h |    2 ++
>  kernel/posix-cpu-timers.c    |   12 ++++++++++++
>  2 files changed, 14 insertions(+)
> 
> Index: linux-2.6-tip/include/linux/posix-timers.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/posix-timers.h
> +++ linux-2.6-tip/include/linux/posix-timers.h
> @@ -85,6 +85,8 @@ struct k_clock {
>  			   struct itimerspec * cur_setting);
>  };
> 
> +extern struct k_clock clock_posix_cpu;
> +
>  void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
> 
>  /* error handlers for timer_create, nanosleep and settime */
> Index: linux-2.6-tip/kernel/posix-cpu-timers.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
> +++ linux-2.6-tip/kernel/posix-cpu-timers.c
> @@ -1604,6 +1604,18 @@ static long thread_cpu_nsleep_restart(st
>  	return -EINVAL;
>  }
> 
> +struct k_clock clock_posix_cpu = {
> +	.clock_getres	= posix_cpu_clock_getres,
> +	.clock_set	= posix_cpu_clock_set,
> +	.clock_get	= posix_cpu_clock_get,
> +	.timer_create	= posix_cpu_timer_create,
> +	.nsleep		= posix_cpu_nsleep,
> +	.nsleep_restart	= posix_cpu_nsleep_restart,
> +	.timer_set	= posix_cpu_timer_set,
> +	.timer_del	= posix_cpu_timer_del,
> +	.timer_get	= posix_cpu_timer_get,
> +};
> +
>  static __init int init_posix_cpu_timers(void)
>  {
>  	struct k_clock process = {
> 
> 


