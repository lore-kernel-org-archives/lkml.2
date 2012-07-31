Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2GaGlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:41:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42019 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2GaGlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:41:02 -0400
Date: Tue, 31 Jul 2012 08:40:53 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx
 clock framework
Message-ID: <20120731064053.GW30009@pengutronix.de>
References: <1343407672-27185-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343407672-27185-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:40:12 up 37 days, 21:51, 43 users,  load average: 0.20, 0.12,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:47:51PM -0300, Fabio Estevam wrote:
> Adapt clocks to the new i.mx clock framework and fix the following warning:
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Herbert Xu <herbert@gondor.apana.org.au> 
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Both:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
> Changes since v1:
> - Converted a missing 'clk_disable' to 'clk_disable_unprepare'
> 
>  drivers/char/hw_random/mxc-rnga.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
> index 85074de..62c7efe 100644
> --- a/drivers/char/hw_random/mxc-rnga.c
> +++ b/drivers/char/hw_random/mxc-rnga.c
> @@ -152,14 +152,14 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
>  	if (rng_dev)
>  		return -EBUSY;
>  
> -	clk = clk_get(&pdev->dev, "rng");
> +	clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(clk)) {
>  		dev_err(&pdev->dev, "Could not get rng_clk!\n");
>  		err = PTR_ERR(clk);
>  		goto out;
>  	}
>  
> -	clk_enable(clk);
> +	clk_prepare_enable(clk);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> @@ -201,7 +201,7 @@ err_ioremap:
>  	release_mem_region(res->start, resource_size(res));
>  
>  err_region:
> -	clk_disable(clk);
> +	clk_disable_unprepare(clk);
>  	clk_put(clk);
>  
>  out:
> @@ -212,7 +212,7 @@ static int __exit mxc_rnga_remove(struct platform_device *pdev)
>  {
>  	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	void __iomem *rng_base = (void __iomem *)mxc_rnga.priv;
> -	struct clk *clk = clk_get(&pdev->dev, "rng");
> +	struct clk *clk = clk_get(&pdev->dev, NULL);
>  
>  	hwrng_unregister(&mxc_rnga);
>  
> @@ -220,7 +220,7 @@ static int __exit mxc_rnga_remove(struct platform_device *pdev)
>  
>  	release_mem_region(res->start, resource_size(res));
>  
> -	clk_disable(clk);
> +	clk_disable_unprepare(clk);
>  	clk_put(clk);
>  
>  	return 0;
> -- 
> 1.7.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
