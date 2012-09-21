Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2IUOAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:00:50 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55758 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2IUOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <1348229149-29040-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 21 Sep 2012 19:30:48 +0530
X-Google-Sender-Auth: OhZQgLTYj3jwX1edWvq6JtJFlaQ
Message-ID: <CAOh2x=mTfy=LfFdB1UL-331b+Rqrxpa=D8rVZ7jaxJJiUT9_zw@mail.gmail.com>
Subject: Re: [PATCHv2 4/6] dw_dmac: autoconfigure block_size or use platform data
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 5:35 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> @@ -1385,6 +1375,7 @@ static int __devinit dw_probe(struct platform_device *pdev)

> +       /* get hardware configuration parameters */
> +       if (autocfg)
> +               max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
> +

Why don't you do above with the below ++ code

>         /* Calculate all channel mask before DMA setup */
>         dw->all_chan_mask = (1 << nr_channels) - 1;
>
> @@ -1470,6 +1465,16 @@ static int __devinit dw_probe(struct platform_device *pdev)
>                 INIT_LIST_HEAD(&dwc->free_list);
>
>                 channel_clear_bit(dw, CH_EN, dwc->mask);
> +
> +               /* hardware configuration */
> +               if (autocfg)
> +                       /* Decode maximum block size for given channel. The
> +                        * stored 4 bit value represents blocks from 0x00 for 3
> +                        * up to 0x0a for 4095. */

i.e. here?

> +                       dwc->block_size =
> +                               (4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;
> +               else
> +                       dwc->block_size = pdata->block_size;
>         }
