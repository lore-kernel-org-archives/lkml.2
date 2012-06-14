Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2FNKlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:41:55 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48004 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420Ab2FNKly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-3-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-3-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:11:14 +0530
Message-ID: <CAMQu2gx75iDwwRJCT4XfSmo3Uux1oroUh8nkr_nEyjAU1qs1hw@mail.gmail.com>
Subject: Re: [PATCH 02/17] i2c: omap: decrease indentation level on data handling
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5EAg1FW031091

On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> trivial patch, no functional changes.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |   63 ++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 9b532cd..39d5583 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -856,22 +856,7 @@ complete:
>                                                        >> 8) & 0x3F;
>                        }
>                        while (num_bytes--) {
> -                               w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
> -                               if (dev->buf_len) {
> -                                       *dev->buf++ = w;
> -                                       dev->buf_len--;
> -                                       /*
> -                                        * Data reg in 2430, omap3 and
> -                                        * omap4 is 8 bit wide
> -                                        */
> -                                       if (dev->flags &
> -                                                OMAP_I2C_FLAG_16BIT_DATA_REG) {
> -                                               if (dev->buf_len) {
> -                                                       *dev->buf++ = w >> 8;
> -                                                       dev->buf_len--;
> -                                               }
> -                                       }
> -                               } else {
> +                               if (!dev->buf_len) {
>                                        if (stat & OMAP_I2C_STAT_RRDY)
>                                                dev_err(dev->dev,
>                                                        "RRDY IRQ while no data"
> @@ -882,6 +867,21 @@ complete:
>                                                                " requested\n");
>                                        break;
>                                }
> +
> +                               w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
> +                               *dev->buf++ = w;
> +                               dev->buf_len--;
> +                               /*
> +                                * Data reg in 2430, omap3 and
> +                                * omap4 is 8 bit wide
> +                                */
> +                               if (dev->flags &
> +                                               OMAP_I2C_FLAG_16BIT_DATA_REG) {
> +                                       if (dev->buf_len) {
> +                                               *dev->buf++ = w >> 8;
> +                                               dev->buf_len--;
> +                                       }
> +                               }
>                        }
>                        omap_i2c_ack_stat(dev,
>                                stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR));
> @@ -898,22 +898,7 @@ complete:
>                                                        & 0x3F;
>                        }
>                        while (num_bytes--) {
> -                               w = 0;
> -                               if (dev->buf_len) {
> -                                       w = *dev->buf++;
> -                                       dev->buf_len--;
> -                                       /*
> -                                        * Data reg in 2430, omap3 and
> -                                        * omap4 is 8 bit wide
> -                                        */
> -                                       if (dev->flags &
> -                                                OMAP_I2C_FLAG_16BIT_DATA_REG) {
> -                                               if (dev->buf_len) {
> -                                                       w |= *dev->buf++ << 8;
> -                                                       dev->buf_len--;
> -                                               }
> -                                       }
> -                               } else {
> +                               if (!dev->buf_len) {
>                                        if (stat & OMAP_I2C_STAT_XRDY)
>                                                dev_err(dev->dev,
>                                                        "XRDY IRQ while no "
> @@ -925,6 +910,20 @@ complete:
>                                        break;
>                                }
>
> +                               w = *dev->buf++;
> +                               dev->buf_len--;
> +                               /*
> +                                * Data reg in 2430, omap3 and
> +                                * omap4 is 8 bit wide
> +                                */
> +                               if (dev->flags &
> +                                               OMAP_I2C_FLAG_16BIT_DATA_REG) {
> +                                       if (dev->buf_len) {
> +                                               w |= *dev->buf++ << 8;
> +                                               dev->buf_len--;
> +                                       }
> +                               }
> +
>                                if ((dev->errata & I2C_OMAP3_1P153) &&
>                                    errata_omap3_1p153(dev, &stat, &err))
>                                        goto complete;

Avoids couple of if check and kills the un-necessary if/else inside the loop.
Did I miss anything else in the patch ?

Looks good to me
Reviewed-by : Santosh Shilimkar <santosh.shilimkar@ti.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
