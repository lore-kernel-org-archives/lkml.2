Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2GFJ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:29:17 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:23023 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2GFJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:29:14 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18oRzo4QuR1oWEQbm8lLTYq
Date: Fri, 6 Jul 2012 01:28:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: jgq516@gmail.com, Wim Van Sebroeck <wim@iguana.be>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com, wim@iguana.be,
        jon-hunter@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCHv2 3/3] watchdog: omap_wdt: add device tree support
Message-ID: <20120706082801.GO1122@atomide.com>
References: <1338525856-4359-1-git-send-email-jgq516@gmail.com>
 <1338525856-4359-4-git-send-email-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338525856-4359-4-git-send-email-jgq516@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

* jgq516@gmail.com <jgq516@gmail.com> [120531 20:56]:
> From: Xiao Jiang <jgq516@gmail.com>
> 
> Add device table for omap_wdt to support dt.

Care to ack this patch in the series?

Regards,

Tony

> 
> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
> ---
>  drivers/watchdog/omap_wdt.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 8285d65..02ebfd5 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -430,6 +430,12 @@ static int omap_wdt_resume(struct platform_device *pdev)
>  #define	omap_wdt_resume		NULL
>  #endif
>  
> +static const struct of_device_id omap_wdt_of_match[] = {
> +	{ .compatible = "ti,omap3-wdt", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
> +
>  static struct platform_driver omap_wdt_driver = {
>  	.probe		= omap_wdt_probe,
>  	.remove		= __devexit_p(omap_wdt_remove),
> @@ -439,6 +445,7 @@ static struct platform_driver omap_wdt_driver = {
>  	.driver		= {
>  		.owner	= THIS_MODULE,
>  		.name	= "omap_wdt",
> +		.of_match_table = omap_wdt_of_match,
>  	},
>  };
>  
> -- 
> 1.7.3
> 
