Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0KETNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:13:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51003 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0KETNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:13:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/d8fK5O7zzZRzo28V3MH0b
Date: Fri, 5 Nov 2010 12:12:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <weber@corscience.de>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP2: Devkit8000: Fix mmc regulator failure
Message-ID: <20101105191247.GR9264@atomide.com>
References: <1288651691-14914-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288651691-14914-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <weber@corscience.de> [101101 14:38]:
> This patch fixes the following error:
> 
> >regulator: VMMC1: 1850 <--> 3150 mV at 3000 mV normal
> standby
> >twl_reg twl_reg.6: can't register VMMC1, -22
> >twl_reg: probe of twl_reg.6 failed with error -22

Adding this into omap-fixes.

Tony
 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 067f437..53ac762 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -242,9 +242,6 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
>  	mmc[0].gpio_cd = gpio + 0;
>  	omap2_hsmmc_init(mmc);
>  
> -	/* link regulators to MMC adapters */
> -	devkit8000_vmmc1_supply.dev = mmc[0].dev;
> -
>  	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
>  	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
>  
> -- 
> 1.7.3.2
> 
