Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949Ab2LSFRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:17:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2LSFRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:17:35 -0500
Date: Wed, 19 Dec 2012 13:15:19 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timekeeping: avoid adjust kernel time once hwclock
 kept in UTC time
Message-ID: <20121219051518.GA8584@zhudong.nay.redhat.com>
References: <20121206140334.GA24261@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206140334.GA24261@zhudong.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 10:03:34PM +0800, Dong Zhu wrote:
> From c126376cf1837b0956e0268056db61870fbbc1d4 Mon Sep 17 00:00:00 2001
> From: Dong Zhu <bluezhudong@gmail.com>
> Date: Thu, 6 Dec 2012 21:45:00 +0800
> Subject: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept in
>  UTC time
> 
> If the Hardware Clock kept in local time,kernel will adjust the time
> to be UTC time.But if Hardware Clock kept in UTC time,system will make
> a dummy settimeofday call first (sys_tz.tz_minuteswest = 0) to make sure
> the time is not shifted,so at this point I think maybe it is not necessary
> to set the kernel time once the sys_tz.tz_minuteswest is zero.
> 
> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> ---
>  kernel/time.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time.c b/kernel/time.c
> index d226c6a..0b592ce 100644
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -134,9 +134,11 @@ static inline void warp_clock(void)
>  {
>  	struct timespec adjust;
>  
> -	adjust = current_kernel_time();
> -	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
> -	do_settimeofday(&adjust);
> +	if (sys_tz.tz_minuteswest) {
> +		adjust = current_kernel_time();
> +		adjust.tv_sec += sys_tz.tz_minuteswest * 60;
> +		do_settimeofday(&adjust);
> +	}
>  }
>  
>  /*
> -- 
> 1.7.11.7
> 

Hi,

Any comments ? 

-- 
Best Regards,
Dong Zhu
