Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab0I0KBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:01:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:51124 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab0I0KBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:01:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,242,1283756400"; 
   d="scan'208";a="558269558"
Date: Mon, 27 Sep 2010 12:01:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Luotao Fu <l.fu@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: stmpe: fix error path
Message-ID: <20100927100141.GC2560@sortiz-mobl>
References: <1284317840-5131-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284317840-5131-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

On Sun, Sep 12, 2010 at 10:57:19PM +0400, Vasiliy Kulikov wrote:
> Free allocated memory.  Call stmpe_disable() if it was enabled.
Patch applied, thanks.


> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
>  Maybe It needs better error path.
> 
>  drivers/gpio/stmpe-gpio.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
> index 65b9960..6e28afa 100644
> --- a/drivers/gpio/stmpe-gpio.c
> +++ b/drivers/gpio/stmpe-gpio.c
> @@ -317,11 +317,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
>  
>  	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
>  	if (ret)
> -		return ret;
> +		goto out_free;
>  
>  	ret = stmpe_gpio_irq_init(stmpe_gpio);
>  	if (ret)
> -		goto out_free;
> +		goto out_disable;
>  
>  	ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq, IRQF_ONESHOT,
>  				   "stmpe-gpio", stmpe_gpio);
> @@ -347,6 +347,8 @@ out_freeirq:
>  	free_irq(irq, stmpe_gpio);
>  out_removeirq:
>  	stmpe_gpio_irq_remove(stmpe_gpio);
> +out_disable:
> +	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
>  out_free:
>  	kfree(stmpe_gpio);
>  	return ret;
> -- 
> 1.7.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
