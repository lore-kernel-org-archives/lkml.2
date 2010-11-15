Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab0KOIy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:54:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54020 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0KOIy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:54:27 -0500
Date: Mon, 15 Nov 2010 09:54:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Atul Sowani <sowani@gmail.com>
Cc: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        ralf@linux-mips.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [PATCH 2.6.36 1/1 RESEND] kernel SPIN_LOCK_UNLOCKED changed to
	__SPIN_LOCK_UNLOCKED()
Message-ID: <20101115085425.GA8942@pengutronix.de>
References: <4CDED96A.9080404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CDED96A.9080404@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Atul,

On Sun, Nov 14, 2010 at 12:01:06AM +0530, Atul Sowani wrote:
> There are still some files containing .lock = SPIN_LOCK_UNLOCKED type
> assignments which should be converted to __SPIN_LOCK_UNLOCKED().
> Corrected spacing between __SPIN_LOCK_UNLOCKED and ( for ARM.
IMHO the last sentence shouldn't appear in the commit log.  (If you
still want to let your readers know what you changed---generally a good
idea---you can do so after the triple-dash below.)

I don't know you patch series, but I'd expect that all archs don't want
the space between __SPIN_LOCK_UNLOCKED and (.

Other than that
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe
> 
> Signed-off-by: Atul Sowani <sowani@gmail.com>
> ---
> 
> diff -uprN a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> --- a/arch/arm/kernel/smp.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/arch/arm/kernel/smp.c	2010-11-07 00:47:32.000000000 +0530
> @@ -56,7 +56,7 @@ struct ipi_data {
>  };
> 
>  static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
> -	.lock	= SPIN_LOCK_UNLOCKED,
> +	.lock	= __SPIN_LOCK_UNLOCKED(ipi_data.lock),
>  };
> 
>  enum ipi_msg_type {
> diff -uprN a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
> --- a/arch/mips/kernel/vpe.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/arch/mips/kernel/vpe.c	2010-11-07 00:51:37.000000000 +0530
> @@ -148,9 +148,9 @@ struct {
>  	spinlock_t tc_list_lock;
>  	struct list_head tc_list;	/* Thread contexts */
>  } vpecontrol = {
> -	.vpe_list_lock	= SPIN_LOCK_UNLOCKED,
> +	.vpe_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.vpe_list_lock),
>  	.vpe_list	= LIST_HEAD_INIT(vpecontrol.vpe_list),
> -	.tc_list_lock	= SPIN_LOCK_UNLOCKED,
> +	.tc_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.tc_list_lock),
>  	.tc_list	= LIST_HEAD_INIT(vpecontrol.tc_list)
>  };
> diff -uprN a/kernel/cred.c b/kernel/cred.c
> --- a/kernel/cred.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/kernel/cred.c	2010-11-07 00:52:22.000000000 +0530
> @@ -35,7 +35,7 @@ static struct kmem_cache *cred_jar;
>  static struct thread_group_cred init_tgcred = {
>  	.usage	= ATOMIC_INIT(2),
>  	.tgid	= 0,
> -	.lock	= SPIN_LOCK_UNLOCKED,
> +	.lock	= __SPIN_LOCK_UNLOCKED(init_tgcred.lock),
>  };
>  #endif
> 
> -- 
> Atul Sowani (sowani@gmail.com)
> http://savannah.gnu.org/users/atul
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
