Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3AII4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:56:42 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42537 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab3AII4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:56:41 -0500
Date: Wed, 9 Jan 2013 08:56:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 3/4] clk: ux500: Provide an alias for the SMSC911x
 Ethernet chip
Message-ID: <20130109085636.GB31678@gmail.com>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
 <1355937587-31730-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355937587-31730-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Lee Jones wrote:

> In the case of some of the ux500 platforms, an Ethernet chip is
> placed on an extended bus which is traditionally used as a NAND
> flash chip placeholder. The p3_pclk0 clock is used to control it,
> so we are required to provide and easy way to access it from the
> SMSC911x driver. We do this using an alias provided by this patch.
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/clk/ux500/u8500_clk.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
> index a601802..9d9add1 100644
> --- a/drivers/clk/ux500/u8500_clk.c
> +++ b/drivers/clk/ux500/u8500_clk.c
> @@ -325,6 +325,7 @@ void u8500_clk_init(void)
>  	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
>  				BIT(0), 0);
>  	clk_register_clkdev(clk, "fsmc", NULL);
> +	clk_register_clkdev(clk, NULL, "smsc911x");
>  
>  	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", U8500_CLKRST3_BASE,
>  				BIT(1), 0);
> -- 
> 1.7.9.5
> 

I still need a maintiner Ack for this before I can push it.

Mike?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
