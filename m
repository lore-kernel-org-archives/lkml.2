Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1AVJpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 04:45:16 -0500
Received: from www.tglx.de ([62.245.132.106]:46070 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1AVJpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:45:14 -0500
Date: Sat, 22 Jan 2011 10:45:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
In-Reply-To: <1295651224-29823-2-git-send-email-torbenh@gmx.de>
Message-ID: <alpine.LFD.2.00.1101221044010.2971@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de> <1295651224-29823-2-git-send-email-torbenh@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Torben Hohn wrote:

Please add a sensible change log, why you move that code.

> Signed-off-by: Torben Hohn <torbenh@gmx.de>
> ---
>  kernel/time/timekeeping.c |   12 ++++++++++++
>  kernel/timer.c            |   13 -------------
>  2 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index d27c756..546d82f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -946,3 +946,15 @@ struct timespec get_monotonic_coarse(void)
>  				now.tv_nsec + mono.tv_nsec);
>  	return now;
>  }
> +
> +/*
> + * The 64-bit jiffies value is not atomic - you MUST NOT read it
> + * without sampling the sequence number in xtime_lock.
> + * jiffies is defined in the linker script...
> + */
> +void do_timer(unsigned long ticks)
> +{
> +	jiffies_64 += ticks;
> +	update_wall_time();
> +	calc_global_load(ticks);
> +}

That also should make update_wall_time() static.

Thanks,

	tglx
