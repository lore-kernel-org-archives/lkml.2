Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1AKPKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:10:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34155 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1AKPKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:10:30 -0500
Date: Tue, 11 Jan 2011 16:10:28 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/16] w1: mxc_w1: don't treat NULL clk as an error
Message-ID: <20110111151028.GT12078@pengutronix.de>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
 <1294749833-32019-17-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294749833-32019-17-git-send-email-jamie@jamieiles.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:10:09 up 8 days, 17 min, 56 users,  load average: 0.18, 0.28,
 0.22
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:43:53PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/w1/masters/mxc_w1.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
> index a3b6a74..67ea082 100644
> --- a/drivers/w1/masters/mxc_w1.c
> +++ b/drivers/w1/masters/mxc_w1.c
> @@ -21,6 +21,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
> +#include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
> @@ -118,8 +119,8 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	mdev->clk = clk_get(&pdev->dev, "owire");
> -	if (!mdev->clk) {
> -		err = -ENODEV;
> +	if (IS_ERR(mdev->clk)) {
> +		err = PTR_ERR(mdev->clk);
>  		goto failed_clk;
>  	}
>  
> -- 
> 1.7.3.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
