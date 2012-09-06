Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2IFHXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:23:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52166 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2IFHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:23:05 -0400
Date: Thu, 6 Sep 2012 09:23:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/3] w1: mxc_w1: Adapt the clock name to the new clock
 framework
Message-ID: <20120906072302.GO26594@pengutronix.de>
References: <1346882480-18254-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346882480-18254-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:21:36 up 74 days, 22:33, 52 users,  load average: 0.15, 0.22,
 0.23
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Wed, Sep 05, 2012 at 07:01:18PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> With the new i.mx clock framework the mxc_w1 clock is registered as:
> 
> clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1.0"
> 
> So we do not need to pass "owire" string and can use NULL instead.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/w1/masters/mxc_w1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
> index 1cc61a7..14f0f66 100644
> --- a/drivers/w1/masters/mxc_w1.c
> +++ b/drivers/w1/masters/mxc_w1.c
> @@ -117,7 +117,7 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
>  	if (!mdev)
>  		return -ENOMEM;
>  
> -	mdev->clk = clk_get(&pdev->dev, "owire");
> +	mdev->clk = clk_get(&pdev->dev, NULL);
>  	if (!mdev->clk) {

You can sell this patch better if you fix the wrong error check here and
'by the way' adjust the lookup string.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
