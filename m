Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1BAUnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:43:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60926 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab1BAUnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:43:10 -0500
Subject: Re: [patch 07/28] posix-timers: Convert clock_nanosleep_restart to
 clockid_to_kclock()
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.131263211@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.131263211@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 12:42:57 -0800
Message-ID: <1296592977.3336.25.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-convert-nanosleep-restart.patch)
> Use the new kclock decoding function in clock_nanosleep_restart. No
> need to check kclock here as the restart block always contains a valid
> clockid. If not, we are in serious trouble anyway.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

One nit.

> -long
> -clock_nanosleep_restart(struct restart_block *restart_block)
> +long clock_nanosleep_restart(struct restart_block *restart_block)
>  {
>  	clockid_t which_clock = restart_block->arg0;
> +	struct k_clock *kc = clockid_to_kclock(which_clock);
> 
> -	return CLOCK_DISPATCH(which_clock, nsleep_restart,
> -			      (restart_block));
> +	return kc->nsleep_restart(restart_block);
>  }


Should you be checking if kc is null before dereferencing? Or am I being
overly paranoid?

thanks
-john


