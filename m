Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1BQKrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:47:11 -0500
Received: from www.tglx.de ([62.245.132.106]:35004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab1BQKrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:47:09 -0500
Date: Thu, 17 Feb 2011 11:47:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: RE: [PATCHv2 09/11] unicore32 core architecture: timer and time
 handling
In-Reply-To: <006a01cbce89$4463e570$cd2bb050$@mprc.pku.edu.cn>
Message-ID: <alpine.LFD.2.00.1102171146140.2701@localhost6.localdomain6>
References: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn> <alpine.LFD.2.00.1102161018370.26192@localhost6.localdomain6> <006a01cbce89$4463e570$cd2bb050$@mprc.pku.edu.cn>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Guan Xuetao wrote:
> That's  ok.
> Please see following patch:

Ok. So you apply that on top of the original bunch, right ?

Fine with me.

     tglx

> From: GuanXuetao <gxt@mprc.pku.edu.cn>
> Date: Thu, 17 Feb 2011 17:50:43 +0800
> Subject: [PATCH] unicore32: apply clockevents_calc_mult_shift()
>    to get rid of shift assignment and mult calculation for osmr0
>    -- by advice with Thomas Gleixner
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  arch/unicore32/kernel/time.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/time.c b/arch/unicore32/kernel/time.c
> index 8090d76..8bb4b81 100644
> --- a/arch/unicore32/kernel/time.c
> +++ b/arch/unicore32/kernel/time.c
> @@ -66,11 +66,6 @@ puv3_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
>  static struct clock_event_device ckevt_puv3_osmr0 = {
>  	.name		= "osmr0",
>  	.features	= CLOCK_EVT_FEAT_ONESHOT,
> -#ifdef CONFIG_ARCH_FPGA
> -	.shift		= 18, /* correct shift val: 16, but warn_on_slowpath */
> -#else
> -	.shift          = 30,
> -#endif
>  	.rating		= 200,
>  	.set_next_event	= puv3_osmr0_set_next_event,
>  	.set_mode	= puv3_osmr0_set_mode,
> @@ -101,8 +96,8 @@ void __init time_init(void)
>  	OST_OIER = 0;		/* disable any timer interrupts */
>  	OST_OSSR = 0;		/* clear status on all timers */
>  
> -	ckevt_puv3_osmr0.mult =
> -		div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt_puv3_osmr0.shift);
> +	clockevents_calc_mult_shift(&ckevt_puv3_osmr0, CLOCK_TICK_RATE, 5);
> +
>  	ckevt_puv3_osmr0.max_delta_ns =
>  		clockevent_delta2ns(0x7fffffff, &ckevt_puv3_osmr0);
>  	ckevt_puv3_osmr0.min_delta_ns =
> -- 
> 1.6.2.2
> 
> > 
> > Thanks,
> > 
> > 	tglx
> 
> Thanks Thomas.
> 
> Guan Xuetao
> 
