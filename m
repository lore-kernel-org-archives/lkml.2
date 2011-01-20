Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1ATLQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:16:54 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:55588 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626Ab1ATLQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:16:52 -0500
Date: Thu, 20 Jan 2011 13:16:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: paul@pwsan.com, tony@atomide.com, r-woodruff2@ti.com,
        linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] omap2: fix DPLL_FREQSEL calculation
Message-ID: <20110120111645.GB2223@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <87ei8726wf.fsf@vostro.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ei8726wf.fsf@vostro.fn.ogness.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 20, 2011 at 11:42:24AM +0100, John Ogness wrote:
> This patch fixes the calculation of the internal frequency. The value
> of "n" is one less than the actual divider. 0 is a valid value.
> 
> An example where the internal frequency is calculated correctly can be
> found here: clkt_dpll.c:_dpll_test_fint()
> 
> This patch is against linux-next-20110120.
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

scripts/get_maintainer.pl would've helped you getting a better Cc list.
I'm adding linux-omap and lakml

> ---
>  arch/arm/mach-omap2/dpll3xxx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/arm/mach-omap2/dpll3xxx.c	2011-01-20 11:20:41.706860086 +0100
> +++ b/arch/arm/mach-omap2/dpll3xxx.c	2011-01-20 11:21:27.966860086 +0100
> @@ -93,7 +93,7 @@ static u16 _omap3_dpll_compute_freqsel(s
>  	unsigned long fint;
>  	u16 f = 0;
>  
> -	fint = clk->dpll_data->clk_ref->rate / n;
> +	fint = clk->dpll_data->clk_ref->rate / (n + 1);
>  
>  	pr_debug("clock: fint is %lu\n", fint);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
balbi
