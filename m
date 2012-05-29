Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2E2SGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:06:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41567 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2E2SGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:06:16 -0400
Message-ID: <4FC51008.1050004@ti.com>
Date: Tue, 29 May 2012 13:06:00 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: <jgq516@gmail.com>
CC: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rnayak@ti.com>, <tony@atomide.com>,
        <wim@iguana.be>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 3/3] watchdog: omap_wdt: add device tree support
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-4-git-send-email-jgq516@gmail.com>
In-Reply-To: <1337942552-28218-4-git-send-email-jgq516@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
> From: Xiao Jiang <jgq516@gmail.com>
> 
> Add device table for omap_wdt to support dt.
> 
> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
> ---
>  drivers/watchdog/omap_wdt.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 8285d65..d98c615 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -430,6 +430,13 @@ static int omap_wdt_resume(struct platform_device *pdev)
>  #define	omap_wdt_resume		NULL
>  #endif
>  
> +static const struct of_device_id omap_wdt_of_match[] = {
> +	{ .compatible = "ti,omap3-wdt", },
> +	{ .compatible = "ti,omap4-wdt", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
> +
>  static struct platform_driver omap_wdt_driver = {
>  	.probe		= omap_wdt_probe,
>  	.remove		= __devexit_p(omap_wdt_remove),
> @@ -439,6 +446,7 @@ static struct platform_driver omap_wdt_driver = {
>  	.driver		= {
>  		.owner	= THIS_MODULE,
>  		.name	= "omap_wdt",
> +		.of_match_table = omap_wdt_of_match,
>  	},
>  };
>  

I think we need to add some code to the probe function that calls
of_match_device() and ensures we find a match. For example ...

	if (of_have_populated_dt())
		if (!of_match_device(omap_wdt_of_match, &pdev->dev))
			return -EINVAL;

Cheers
Jon
