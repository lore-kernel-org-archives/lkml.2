Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0EAMVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 08:21:16 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36962 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0EAMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 08:21:15 -0400
Date: Sat, 1 May 2010 14:21:10 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       r.herring@freescale.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Subject: Re: [PATCHv10 2.6.34-rc6 4/5] mxc: Add generic USB HW
 initialization for MX51
Message-ID: <20100501122110.GC30801@buzzloop.caiaq.de>
References: <1272660507-5917-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1272660507-5917-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1272660507-5917-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1272660507-5917-4-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272660507-5917-4-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 03:48:26PM -0500, Dinh.Nguyen@freescale.com wrote:

[...]

> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index ead59f4..544ccfd 100644
> --- a/drivers/usb/host/ehci-mxc.c
> +++ b/drivers/usb/host/ehci-mxc.c
> @@ -199,8 +199,8 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
>  	writel(pdata->portsc, hcd->regs + PORTSC_OFFSET);
>  	mdelay(10);
>  
> -	/* setup USBCONTROL. */
> -	ret = mxc_set_usbcontrol(pdev->id, pdata->flags);
> +	/* setup specific usb hw */
> +	ret = mxc_initialize_usb_hw(pdev->id, pdata->flags);
>  	if (ret < 0)
>  		goto err_init;

Ok - now we shouldn't have any possible regression.

Thanks,
Daniel
