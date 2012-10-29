Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965Ab2J2VAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:00:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691Ab2J2VAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:00:42 -0400
Date: Mon, 29 Oct 2012 22:00:35 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] rtc-imxdi: Add devicetree support
Message-ID: <20121029210035.GV1641@pengutronix.de>
References: <1350576370-29098-1-git-send-email-stigge@antcom.de>
 <1350576370-29098-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350576370-29098-2-git-send-email-stigge@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:00:10 up 128 days, 12:11, 39 users,  load average: 0.52, 0.52,
 0.43
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 06:06:09PM +0200, Roland Stigge wrote:
> This patch adds device tree support to the rtc-imxdi driver.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> ---
>  Documentation/devicetree/bindings/rtc/imxdi-rtc.txt |   17 +++++++++++++++++
>  drivers/rtc/rtc-imxdi.c                             |   11 +++++++++++
>  2 files changed, 28 insertions(+)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/rtc/imxdi-rtc.txt
> @@ -0,0 +1,17 @@
> +* i.MX25 Real Time Clock controller
> +
> +This binding supports the following chips: i.MX25, i.MX53
> +
> +Required properties:
> +- compatible: should be: "fsl,imx25-rtc"
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +- interrupts: rtc alarm interrupt
> +
> +Example:
> +
> +rtc@80056000 {
> +	compatible = "fsl,imx53-rtc", "fsl,imx25-rtc";
> +	reg = <0x80056000 2000>;
> +	interrupts = <29>;
> +};
> --- linux-2.6.orig/drivers/rtc/rtc-imxdi.c
> +++ linux-2.6/drivers/rtc/rtc-imxdi.c
> @@ -37,6 +37,7 @@
>  #include <linux/rtc.h>
>  #include <linux/sched.h>
>  #include <linux/workqueue.h>
> +#include <linux/of.h>
>  
>  /* DryIce Register Definitions */
>  
> @@ -493,10 +494,20 @@ static int __devexit dryice_rtc_remove(s
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id dryice_dt_ids[] = {
> +	{ .compatible = "fsl,imx25-rtc" },
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, dryice_dt_ids);
> +#endif
> +
>  static struct platform_driver dryice_rtc_driver = {
>  	.driver = {
>  		   .name = "imxdi_rtc",
>  		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(dryice_dt_ids),
>  		   },
>  	.remove = __devexit_p(dryice_rtc_remove),
>  };
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
