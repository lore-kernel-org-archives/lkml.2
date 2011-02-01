Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1BAVWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:22:34 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49558 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1BAVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:22:33 -0500
Subject: Re: [patch 16/28] posix-timers: Convert timer_settime() to
 clockid_to_kclock()
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.001863714@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.001863714@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:22:24 -0800
Message-ID: <1296595344.3336.60.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment (posix-timers-convert-timer-set.patch)
> Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
> and use the new decoding function. No need to check for the return
> value of it. If we have data corruption in the timer, we explode
> somewhere else anyway. Also all kclocks which implement timer_create()
> need to provide timer_settime() as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
[snip]
> @@ -818,8 +821,8 @@ retry:
>  	if (!timr)
>  		return -EINVAL;
> 
> -	error = CLOCK_DISPATCH(timr->it_clock, timer_set,
> -			       (timr, flags, &new_spec, rtn));
> +	kc = clockid_to_kclock(timr->it_clock);
> +	error = kc->timer_set(timr, flags, &new_spec, rtn);

Again, me being paraniod, would probably want a null check on kc here.
Also, as you suggested on irc, a WARN_ON_ONCE(), since it means kernel
data has been munged.


thanks
-john

