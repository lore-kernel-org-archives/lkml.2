Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LEHcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:32:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42552 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1LEHcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:32:06 -0500
Date: Mon, 5 Dec 2011 08:31:53 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PTP] Implement clock_getres() function correctly
Message-ID: <20111205073153.GA1460@cherladcori01>
References: <alpine.LFD.2.02.1112041801000.2735@ionos>
 <alpine.LFD.2.02.1112041806550.2735@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112041806550.2735@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 06:07:43PM +0100, Thomas Gleixner wrote:
> On Sun, 4 Dec 2011, Thomas Gleixner wrote:
> 
> > clock_getres() needs to put the resolution into the provided timespec
> > and return 0 in case of success.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@vger.kernel.org
> 
> Gah, wrong version.

Thanks for spotting that weird left over (from the old posix-timer.c
code).

Acked-by: Richard Cochran <richardcochran@gmail.com>

BTW, my email address has changed. Did you see my patch for
MAINTAINERS a few weeks back? It would help when finding the current
email address.

Thanks,
Richard

 
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
