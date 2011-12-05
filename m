Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1LELa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:30:57 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45068 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab1LELaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:30:55 -0500
MIME-Version: 1.0
In-Reply-To: <1323083592.6763.5.camel@phoenix>
References: <1323083592.6763.5.camel@phoenix>
Date: Mon, 5 Dec 2011 19:30:54 +0800
Message-ID: <CAN1soZyrtbheNDJU=vbHFY8fu2O3Q_g2dGoO1hjSaSErL1ObnQ@mail.gmail.com>
Subject: Re: [PATCH] Input: zylonite-wm97xx - replace IRQ_GPIO() with gpio_to_irq()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 7:13 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
> I got below buid errors due to implicit declaration of function 'IRQ_GPIO'.
>
> Use common gpio_to_irq() to replace machine dependant macro IRQ_GPIO().
>
>  CC      drivers/input/touchscreen/zylonite-wm97xx.o
> drivers/input/touchscreen/zylonite-wm97xx.c: In function 'zylonite_wm97xx_probe':
> drivers/input/touchscreen/zylonite-wm97xx.c:195: error: implicit declaration of function 'IRQ_GPIO'
> make[3]: *** [drivers/input/touchscreen/zylonite-wm97xx.o] Error 1
> make[2]: *** [drivers/input/touchscreen] Error 2
> make[1]: *** [drivers/input] Error 2
> make: *** [drivers] Error 2
>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I got the build error in linux-next tree,
> thus this patch is against linux-next (20111205).
>
> Axel
>  drivers/input/touchscreen/zylonite-wm97xx.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
> index add6e3b..bf0869a7 100644
> --- a/drivers/input/touchscreen/zylonite-wm97xx.c
> +++ b/drivers/input/touchscreen/zylonite-wm97xx.c
> @@ -22,6 +22,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -192,8 +193,8 @@ static int zylonite_wm97xx_probe(struct platform_device *pdev)
>        else
>                gpio_touch_irq = mfp_to_gpio(MFP_PIN_GPIO26);
>
> -       wm->pen_irq = IRQ_GPIO(gpio_touch_irq);
> -       irq_set_irq_type(IRQ_GPIO(gpio_touch_irq), IRQ_TYPE_EDGE_BOTH);
> +       wm->pen_irq = gpio_to_irq(gpio_touch_irq);
> +       irq_set_irq_type(wm->pen_irq, IRQ_TYPE_EDGE_BOTH);
>
>        wm97xx_config_gpio(wm, WM97XX_GPIO_13, WM97XX_GPIO_IN,
>                           WM97XX_GPIO_POL_HIGH,
> --

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
