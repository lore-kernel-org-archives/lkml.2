Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1AZIKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:10:52 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:48479 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab1AZIKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:10:50 -0500
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
From: Sven Neumann <s.neumann@raumfeld.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
In-Reply-To: <AANLkTinrxiHx6jX9jFzVzjq5FH-W=MLoDThAtRq2a1zZ@mail.gmail.com>
References: <20110124101701.GE16202@n2100.arm.linux.org.uk>
	 <1295864750-1238-1-git-send-email-s.neumann@raumfeld.com>
	 <AANLkTinrxiHx6jX9jFzVzjq5FH-W=MLoDThAtRq2a1zZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Wed, 26 Jan 2011 09:10:47 +0100
Message-ID: <1296029447.2013.8.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1296029450;e18e6a74;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 05:06 +0800, Eric Miao wrote:
> How about this instead?
> 
> diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
> index 978e1b2..1807c9a 100644
> --- a/arch/arm/mach-pxa/pm.c
> +++ b/arch/arm/mach-pxa/pm.c
> @@ -33,7 +33,7 @@ int pxa_pm_enter(suspend_state_t state)
>  #endif
> 
>  	/* skip registers saving for standby */
> -	if (state != PM_SUSPEND_STANDBY) {
> +	if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->save) {
>  		pxa_cpu_pm_fns->save(sleep_save);
>  		/* before sleeping, calculate and save a checksum */
>  		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
> @@ -44,7 +44,7 @@ int pxa_pm_enter(suspend_state_t state)
>  	pxa_cpu_pm_fns->enter(state);
>  	cpu_init();
> 
> -	if (state != PM_SUSPEND_STANDBY) {
> +	if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->restore) {
>  		/* after sleeping, validate the checksum */
>  		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
>  			checksum += sleep_save[i];
> 

Not sure if that will work as well. With this change the code is
skipping more than just the calls to pxa_cpu_pm_fns->save() and
pxa_cpu_pm_fns->restore(). In particular it doesn't call
pxa_cpu_pm_fns->enter(state).


Thanks,
Sven


