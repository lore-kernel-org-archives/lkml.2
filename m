Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2KPN4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:56:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:43946 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2KPN4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:56:54 -0500
Message-ID: <50A64624.6010902@atmel.com>
Date: Fri, 16 Nov 2012 14:56:52 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-watchdog@vger.kernel.org>,
        <JM.Lin@atmel.com>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <wim@iguana.be>, <plagnioj@jcrosoft.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 09/11] watchdog/at91sam9_wdt: add support to device tree
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com> <1352877369-19740-10-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1352877369-19740-10-git-send-email-wenyou.yang@atmel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 08:16 AM, Wenyou Yang :
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

No. The work has already been done by Fabio Porcedda and he managed to
sustain the discussion and reach a consensus at his v9 patch series: so
please take into account his work and build yours on top of his patch
series.

Best regards,

> Cc: grant.likely@secretlab.ca
> Cc: rob.herring@calxeda.com
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
>  drivers/watchdog/at91sam9_wdt.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index e7ce9ea..cba5c5d 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -32,6 +32,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/timer.h>
>  #include <linux/bitops.h>
> +#include <linux/of.h>
>  
>  #include "at91sam9_wdt.h"
>  
> @@ -251,12 +252,21 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id at91wdt_match[] = {
> +	{ .compatible = "atmel,at91sam-wdt" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, at91wdt_match);
> +#endif
> +
>  static struct platform_driver at91wdt_driver = {
>  	.probe		= at91wdt_probe,
>  	.remove		= __exit_p(at91wdt_remove),
>  	.driver		= {
>  		.name	= "at91_wdt",
>  		.owner	= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(at91wdt_match),
>  	},
>  };
>  
> 


-- 
Nicolas Ferre
