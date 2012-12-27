Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2L0KG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 05:06:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42718 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2L0KG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 05:06:57 -0500
Date: Thu, 27 Dec 2012 11:06:51 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: drm/imx: check return value of ipu_reset()
Message-ID: <20121227100651.GT26326@pengutronix.de>
References: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:06:20 up 187 days,  1:17, 14 users,  load average: 0.42, 0.35,
 0.33
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 03:58:37PM +0100, Lothar Waﬂmann wrote:
> ipu_reset() can fail with a timeout. Check the return value and act
> appropriately.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

All:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> index 677e665..f7059cd 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> @@ -1104,7 +1104,9 @@ static int ipu_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_failed_irq;
>  
> -	ipu_reset(ipu);
> +	ret = ipu_reset(ipu);
> +	if (ret)
> +		goto out_failed_reset;
>  
>  	/* Set MCU_T to divide MCU access window into 2 */
>  	ipu_cm_write(ipu, 0x00400000L | (IPU_MCU_T_DEFAULT << 18),
> @@ -1129,6 +1131,7 @@ failed_add_clients:
>  	ipu_submodules_exit(ipu);
>  failed_submodules_init:
>  	ipu_irq_exit(ipu);
> +out_failed_reset:
>  out_failed_irq:
>  	clk_disable_unprepare(ipu->clk);
>  failed_clk_get:
> -- 
> 1.7.2.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
