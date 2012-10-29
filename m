Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962Ab2J2VDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:03:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60696 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650Ab2J2VDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:03:19 -0400
Date: Mon, 29 Oct 2012 22:03:16 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mach-imx: Support for DryIce RTC in i.MX53
Message-ID: <20121029210316.GW1641@pengutronix.de>
References: <1350576370-29098-1-git-send-email-stigge@antcom.de>
 <1350576370-29098-3-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350576370-29098-3-git-send-email-stigge@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:03:05 up 128 days, 12:14, 39 users,  load average: 0.66, 0.53,
 0.44
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 06:06:10PM +0200, Roland Stigge wrote:
> This patch enables support for i.MX53 in addition to i.MX25 by providing a
> dummy clock on i.MX53 since this one doesn't have a separate clock for internal
> RTC but the driver requests one.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied, thanks

Sascha

> ---
>  arch/arm/mach-imx/clk-imx51-imx53.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.orig/arch/arm/mach-imx/clk-imx51-imx53.c
> +++ linux-2.6/arch/arm/mach-imx/clk-imx51-imx53.c
> @@ -467,6 +467,7 @@ int __init mx53_clocks_init(unsigned lon
>  	clk_register_clkdev(clk[can1_serial_gate], "per", "53fc8000.can");
>  	clk_register_clkdev(clk[can2_ipg_gate], "ipg", "53fcc000.can");
>  	clk_register_clkdev(clk[can2_serial_gate], "per", "53fcc000.can");
> +	clk_register_clkdev(clk[dummy], NULL, "53fa4000.rtc");
>  
>  	/* set SDHC root clock to 200MHZ*/
>  	clk_set_rate(clk[esdhc_a_podf], 200000000);
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
