Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2GWUAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:00:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49621 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2GWUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:00:49 -0400
Date: Mon, 23 Jul 2012 15:51:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: xen-devel@lists.xensource.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Was: Re: [GIT PULL] timer changes for v3.6, Is:
 Regression introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
Message-ID: <20120723195144.GA3454@phenom.dumpdata.com>
References: <20120722133441.GA6874@gmail.com>
 <20120723144917.GF793@phenom.dumpdata.com>
 <500D8CDD.3060309@linaro.org>
 <20120723182431.GD21870@phenom.dumpdata.com>
 <500D9EBC.204@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D9EBC.204@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the following resolve it? If not I have a debug patch I'll send
> you to try to chase this down.

Yup. That makes it boot without crash and without any WARN_ON.  I am going
to run it overnight on some other machines but so far it looks to have
fixed the regression. So please attach:

Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> 
> thanks
> -john
> 
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f045cc5..cf364db 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -108,13 +108,13 @@ static struct timespec tk_xtime(struct timekeeper *tk)
>  static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
>  {
>  	tk->xtime_sec = ts->tv_sec;
> -	tk->xtime_nsec = ts->tv_nsec << tk->shift;
> +	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
>  }
>  static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
>  {
>  	tk->xtime_sec += ts->tv_sec;
> -	tk->xtime_nsec += ts->tv_nsec << tk->shift;
> +	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
>  }
>  /**
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
