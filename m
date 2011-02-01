Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1BAV0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:26:07 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52862 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1BAV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:26:04 -0500
Subject: Re: [patch 19/28] posix-timers: Remove CLOCK_DISPATCH leftovers
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.294620613@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.294620613@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:25:59 -0800
Message-ID: <1296595559.3336.64.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-remove-clock-dispatch-leftovers.patch)
> All users gone. Remove the cruft.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
> ---
>  kernel/posix-timers.c |   22 ----------------------
>  1 file changed, 22 deletions(-)
> 
> Index: linux-2.6-tip/kernel/posix-timers.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/posix-timers.c
> +++ linux-2.6-tip/kernel/posix-timers.c
> @@ -167,28 +167,6 @@ static inline void unlock_timer(struct k
>  	spin_unlock_irqrestore(&timr->it_lock, flags);
>  }
> 
> -/*
> - * Call the k_clock hook function if non-null, or the default function.
> - */
> -#define CLOCK_DISPATCH(clock, call, arglist) \
> - 	((clock) < 0 ? posix_cpu_##call arglist : \
> - 	 (posix_clocks[clock].call != NULL \
> - 	  ? (*posix_clocks[clock].call) arglist : common_##call arglist))
> -

Big thanks to Richard and Thomas for killing this bit of ugliness!

Acked-by: John Stultz <johnstul@us.ibm.com>


