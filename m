Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1JQTKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:10:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59219 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1JQTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:10:11 -0400
Subject: Re: [PATCH] timekeeping: fix bogus comment in
 timekeeping_get_ns_raw
From: john stultz <johnstul@us.ibm.com>
To: Dan McGee <dpmcgee@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1318877923-17792-1-git-send-email-dpmcgee@gmail.com>
References: <1318877923-17792-1-git-send-email-dpmcgee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 12:09:41 -0700
Message-ID: <1318878581.3125.81.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11101719-7282-0000-0000-0000028FD4DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 13:58 -0500, Dan McGee wrote:
> The whole point of this function is to return a value not touched by
> NTP; unfortunately the comment got copied wholesale without adjustment
> from the timekeeping_get_ns function above.
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>
> ---
>  kernel/time/timekeeping.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 2b021b0e..a5846a8 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -131,7 +131,7 @@ static inline s64 timekeeping_get_ns_raw(void)
>  	/* calculate the delta since the last update_wall_time: */
>  	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> 
> -	/* return delta convert to nanoseconds using ntp adjusted mult. */
> +	/* return delta convert to nanoseconds. */
>  	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
>  }

Thanks for catching this! I'll apply it to my queue!
-john


