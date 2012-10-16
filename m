Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2JPUPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:15:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55309 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2JPUPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:15:37 -0400
Date: Tue, 16 Oct 2012 22:15:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] rtc-imxdi: Support for i.MX53
Message-ID: <20121016201528.GW27665@pengutronix.de>
References: <1350399095-2955-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350399095-2955-1-git-send-email-stigge@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:13:37 up 115 days, 11:25, 44 users,  load average: 6.31, 7.58,
 8.26
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 04:51:34PM +0200, Roland Stigge wrote:
> This patch enables support for i.MX53 in addition to i.MX25
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> ---
>  drivers/rtc/Kconfig     |    2 +-
>  drivers/rtc/rtc-imxdi.c |   25 ++++++++++++++++---------
>  2 files changed, 17 insertions(+), 10 deletions(-)
> 
> --- linux-2.6.orig/drivers/rtc/Kconfig
> +++ linux-2.6/drivers/rtc/Kconfig
> @@ -768,7 +768,7 @@ config RTC_DRV_DAVINCI
>  
>  config RTC_DRV_IMXDI
>  	tristate "Freescale IMX DryIce Real Time Clock"
> -	depends on SOC_IMX25
> +	depends on SOC_IMX25 || SOC_IMX53

Please do not add new SoC dependencies. Use ARCH_MXC as a dependency
instead.

> +	/* For IMX53, RTC is available always */
> +	if (cpu_is_mx25()) {
> +		imxdi->clk = clk_get(&pdev->dev, NULL);
> +		if (IS_ERR(imxdi->clk))
> +			return PTR_ERR(imxdi->clk);
> +		clk_prepare_enable(imxdi->clk);
> +	}

No new users of cpu_is_* macros please. Provide a dummy clock
for i.MX53 instead.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
