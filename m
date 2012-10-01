Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2JARmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:42:52 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33515 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab2JARmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:42:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd25he5bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1155h)
Message-ID: <5069D830.6070307@freescale.com>
Date: Mon, 1 Oct 2012 14:51:44 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: <zbr@ioremap.net>
CC: <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <festevam@gmail.com>
Subject: Re: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new clock
 framework
References: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeny,

Any comments, please?


Fabio Estevam wrote:
> With the new i.mx clock framework the mxc_w1 clock is registered as:
> 
> clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1.0"
> 
> So we do not need to pass "owire" string and can use NULL instead.
> 
> While at it, also fix the clock error handling code.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> -----
> Changes since v1:
> - Fix clock error handling
>  drivers/w1/masters/mxc_w1.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
> index 1cc61a7..960b362 100644
> --- a/drivers/w1/masters/mxc_w1.c
> +++ b/drivers/w1/masters/mxc_w1.c
> @@ -117,11 +117,11 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
>  	if (!mdev)
>  		return -ENOMEM;
>  
> -	mdev->clk = clk_get(&pdev->dev, "owire");
> -	if (!mdev->clk) {
> -		err = -ENODEV;
> -		goto failed_clk;
> -	}
> +	mdev->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(mdev->clk)) {
> +		err = PTR_ERR(mdev->clk);
> +		goto failed_clk;
> +	}
>  
>  	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
>  


