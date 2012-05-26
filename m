Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2EZLaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:30:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36403 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2EZL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:29:54 -0400
Date: Sat, 26 May 2012 13:29:46 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] hw_random: mxc-rnga: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20120526112946.GW30400@pengutronix.de>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
 <1337987696-31728-3-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337987696-31728-3-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:29:17 up 195 days, 19:16, 39 users,  load average: 12.75, 5.91,
 3.42
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 08:14:44PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Prepare the clock before enabling it.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/char/hw_random/mxc-rnga.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
> index 187c6be..6f20f56 100644
> --- a/drivers/char/hw_random/mxc-rnga.c
> +++ b/drivers/char/hw_random/mxc-rnga.c
> @@ -154,7 +154,7 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
>  		goto out;
>  	}
>  
> -	clk_enable(clk);
> +	clk_prepare_enable(clk);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> @@ -196,7 +196,7 @@ err_ioremap:
>  	release_mem_region(res->start, resource_size(res));
>  
>  err_region:
> -	clk_disable(clk);
> +	clk_disable_unprepare(clk);

You forgot the clk_disable_unprepare in the remove path.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
