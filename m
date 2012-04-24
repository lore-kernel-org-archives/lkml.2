Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2DXJv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:51:29 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:22686
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198Ab2DXJv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:51:26 -0400
X-SpamScore: -3
X-BigFish: VS-3(zcb8kz1432Nzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 24 Apr 2012 17:51:17 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>
Subject: Re: [PATCH v2 3/3] ARM: imx6q: switch to use pinctrl driver
Message-ID: <20120424095116.GA28063@b20223-02.ap.freescale.net>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
 <1334933916-12971-3-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334933916-12971-3-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -24,6 +24,7 @@
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
> +#include <linux/pinctrl/consumer.h>
>  #include <mach/esdhc.h>
>  #include "sdhci-pltfm.h"
>  #include "sdhci-esdhc.h"
> @@ -68,6 +69,7 @@ struct pltfm_imx_data {
>  	int flags;
>  	u32 scratchpad;
>  	enum imx_esdhc_type devtype;
> +	struct pinctrl *p;
>  	struct esdhc_platform_data boarddata;
>  };
>  
> @@ -467,6 +469,12 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  	clk_prepare_enable(clk);
>  	pltfm_host->clk = clk;
>  
> +	imx_data->p = pinctrl_get_select_default(&pdev->dev);
devm_xxx version?

Thanks
Richard 

