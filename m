Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2IUHa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:30:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54117 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2IUHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8ZQr2-1B2QcwO83gJNBrzw-WY1WWgWQJJCQYxirVAC2Q@mail.gmail.com>
References: <CAPgLHd8ZQr2-1B2QcwO83gJNBrzw-WY1WWgWQJJCQYxirVAC2Q@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 21 Sep 2012 15:30:33 +0800
Message-ID: <CAMPhdO-+7myDOLNxRs8Pi78for3g8+-npsY+EbOa+sxoW=2C1w@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix return value check in pxa2xx_drv_pcmcia_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 3:19 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function clk_get() returns ERR_PTR()
> and never returns NULL pointer. The NULL test in the error
> handling should be replaced with IS_ERR().
>
> dpatch engine is used to auto generated this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Ack

> ---
>  drivers/pcmcia/pxa2xx_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
> index 490bb82..cfec9dd 100644
> --- a/drivers/pcmcia/pxa2xx_base.c
> +++ b/drivers/pcmcia/pxa2xx_base.c
> @@ -297,7 +297,7 @@ static int pxa2xx_drv_pcmcia_probe(struct platform_device *dev)
>         }
>
>         clk = clk_get(&dev->dev, NULL);
> -       if (!clk)
> +       if (IS_ERR(clk))
>                 return -ENODEV;
>
>         pxa2xx_drv_pcmcia_ops(ops);
>
>
