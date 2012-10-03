Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2JCKLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:11:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53996 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2JCKLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:11:16 -0400
Date: Wed, 3 Oct 2012 12:11:12 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new clock
 framework
Message-ID: <20121003101112.GD1322@pengutronix.de>
References: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:10:51 up 102 days,  1:22, 26 users,  load average: 0.82, 0.77,
 0.71
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 01:48:59PM -0300, Fabio Estevam wrote:
> With the new i.mx clock framework the mxc_w1 clock is registered as:
> 
> clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1.0"
> 
> So we do not need to pass "owire" string and can use NULL instead.
> 
> While at it, also fix the clock error handling code.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> -----
> Changes since v1:
> - Fix clock error handling
>  drivers/w1/masters/mxc_w1.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
> index 1cc61a7..960b362 100644
> --- a/drivers/w1/masters/mxc_w1.c
> +++ b/drivers/w1/masters/mxc_w1.c
> @@ -117,11 +117,11 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
>  	if (!mdev)
>  		return -ENOMEM;
>  
> -	mdev->clk = clk_get(&pdev->dev, "owire");
> -	if (!mdev->clk) {
> -		err = -ENODEV;
> -		goto failed_clk;
> -	}
> +	mdev->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(mdev->clk)) {
> +		err = PTR_ERR(mdev->clk);
> +		goto failed_clk;
> +	}
>  
>  	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
>  
> -- 
> 1.7.9.5
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
