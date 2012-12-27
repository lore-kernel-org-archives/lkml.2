Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2L0Ktg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 05:49:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34399 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2L0Kte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 05:49:34 -0500
Date: Thu, 27 Dec 2012 11:49:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] ehci-mxc: remove Efika MX-specific CHRGVBUS hack
Message-ID: <20121227104929.GW26326@pengutronix.de>
References: <1356261362-8418-1-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356261362-8418-1-git-send-email-matt@genesi-usa.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:49:06 up 187 days,  2:00, 14 users,  load average: 0.26, 0.38,
 0.40
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 05:16:02AM -0600, Matt Sealey wrote:
> Since Efika MX platform support (pre-devicetree) was removed from the tree
> this code no longer has any possibility of running and clutters up the
> driver which is being replaced by the chipidea host in the future anyway.
> 
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
> Tested-by: Steev Klimazewski <steev@genesi-usa.com>
> CC: Sascha Hauer <kernel@pengutronix.de>
> CC: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> 
> ---
>  drivers/usb/host/ehci-mxc.c |   20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index 8e58a5f..b62c3a8 100644
> --- a/drivers/usb/host/ehci-mxc.c
> +++ b/drivers/usb/host/ehci-mxc.c
> @@ -102,7 +102,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
>  	struct usb_hcd *hcd;
>  	struct resource *res;
>  	int irq, ret;
> -	unsigned int flags;
>  	struct ehci_mxc_priv *priv;
>  	struct device *dev = &pdev->dev;
>  	struct ehci_hcd *ehci;
> @@ -213,25 +212,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_add;
>  
> -	if (pdata->otg) {
> -		/*
> -		 * efikamx and efikasb have some hardware bug which is
> -		 * preventing usb to work unless CHRGVBUS is set.
> -		 * It's in violation of USB specs
> -		 */
> -		if (machine_is_mx51_efikamx() || machine_is_mx51_efikasb()) {
> -			flags = usb_phy_io_read(pdata->otg,
> -							ULPI_OTG_CTRL);
> -			flags |= ULPI_OTG_CTRL_CHRGVBUS;
> -			ret = usb_phy_io_write(pdata->otg, flags,
> -							ULPI_OTG_CTRL);
> -			if (ret) {
> -				dev_err(dev, "unable to set CHRVBUS\n");
> -				goto err_add;
> -			}
> -		}
> -	}
> -
>  	return 0;
>  
>  err_add:
> -- 
> 1.7.10.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
