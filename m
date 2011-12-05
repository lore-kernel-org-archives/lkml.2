Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab1LETDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:03:34 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34661 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab1LETDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:03:33 -0500
Message-ID: <1323111761.21423.229.camel@work-vm>
Subject: Re: [PTP] Implement clock_getres() function correctly
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>
Date: Mon, 05 Dec 2011 11:02:41 -0800
In-Reply-To: <alpine.LFD.2.02.1112041806550.2735@ionos>
References: <alpine.LFD.2.02.1112041801000.2735@ionos>
	 <alpine.LFD.2.02.1112041806550.2735@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120519-5518-0000-0000-000000D0D27D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-04 at 18:07 +0100, Thomas Gleixner wrote:
> On Sun, 4 Dec 2011, Thomas Gleixner wrote:
> 
> > clock_getres() needs to put the resolution into the provided timespec
> > and return 0 in case of success.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@vger.kernel.org
> 
> Gah, wrong version.
> 
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index cf3f999..6b0c02a 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -101,7 +101,10 @@ static s32 scaled_ppm_to_ppb(long ppm)
> 
>  static int ptp_clock_getres(struct posix_clock *pc, struct timespec *tp)
>  {
> -	return 1; /* always round timer functions to one nanosecond */
> +	/* Resolution is one nanosecond */
> +	tp->tv_sec = 0;
> +	tp->tv_nsec = 1;
> +	return 0;
>  }
> 
>  static int ptp_clock_settime(struct posix_clock *pc, const struct timespec *tp)


Looks good.

Acked-by: John Stultz <john.stultz@linaro.org>


