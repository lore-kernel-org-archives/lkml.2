Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1BAVYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:24:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39249 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1BAVYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:24:23 -0500
Subject: Re: [patch 18/28] posix-timers: Convert timer_delete() to
 clockid_to_kclock()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.198999420@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.198999420@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:24:17 -0800
Message-ID: <1296595457.3336.62.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment (posix-timers-convert-timer-del.patch)
> Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
> and use the new decoding function. No need to check for the return
> value of it. If we have data corruption in the timer, we explode
> somewhere else anyway. Also all kclocks which implement timer_create()
> need to provide timer_delete() as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
> ---
[snip]
> @@ -852,7 +854,9 @@ static inline int common_timer_del(struc
> 
>  static inline int timer_delete_hook(struct k_itimer *timer)
>  {
> -	return CLOCK_DISPATCH(timer->it_clock, timer_del, (timer));
> +	struct k_clock *kc = clockid_to_kclock(timer->it_clock);
> +
> +	return kc->timer_del(timer);
>  }

Again, kc == NULL check. 

thanks
-john

