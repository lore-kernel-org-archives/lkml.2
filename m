Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab2KALGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:06:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33599 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab2KALGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:06:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Wei Yongjun <weiyj.lk@gmail.com>, <peter.ujfalusi@ti.com>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <CAPgLHd-LVhPkOHUWOwjmcsDA-4spfQMTxW9z2tB7fnEuS_5OOw@mail.gmail.com>
CC: <yongjun_wei@trendmicro.com.cn>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <CAPgLHd-LVhPkOHUWOwjmcsDA-4spfQMTxW9z2tB7fnEuS_5OOw@mail.gmail.com>
Message-ID: <20121101110636.22860.46946@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH -next] CLK: clk-twl6040: fix return value check in
 twl6040_clk_probe()
Date: Thu, 1 Nov 2012 04:06:36 -0700
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Wei Yongjun (2012-10-31 22:33:55)
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_register() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks for the patch.  Will take into clk-next.

Regards,
Mike

> ---
>  drivers/clk/clk-twl6040.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
> index f4a3389..bc1e713 100644
> --- a/drivers/clk/clk-twl6040.c
> +++ b/drivers/clk/clk-twl6040.c
> @@ -92,8 +92,8 @@ static int __devinit twl6040_clk_probe(struct platform_device *pdev)
>  
>         clkdata->mcpdm_fclk.init = &wm831x_clkout_init;
>         clkdata->clk = clk_register(&pdev->dev, &clkdata->mcpdm_fclk);
> -       if (!clkdata->clk)
> -               return -EINVAL;
> +       if (IS_ERR(clkdata->clk))
> +               return PTR_ERR(clkdata->clk);
>  
>         dev_set_drvdata(&pdev->dev, clkdata);
