Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2KLNyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:54:51 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50604 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2KLNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:54:50 -0500
MIME-Version: 1.0
In-Reply-To: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 12 Nov 2012 19:24:49 +0530
X-Google-Sender-Auth: -sFOqXPtv_CEJCv_t0Y67NBsNZM
Message-ID: <CAOh2x=m9TyMOhh=nCD0nznEBy6jN7eUddp7hLT7TnCf0xM07dA@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: absence of pdata isn't critical when autocfg is set
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 4:53 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

>  static int __devinit dw_probe(struct platform_device *pdev)
>  {
>         struct dw_dma_platform_data *pdata;
> @@ -1604,9 +1610,6 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         if (!pdata)
>                 pdata = dw_dma_parse_dt(pdev);
>
> -       if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
> -               return -EINVAL;
> -
>         io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!io)
>                 return -EINVAL;
> @@ -1622,6 +1625,12 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         dw_params = dma_read_byaddr(regs, DW_PARAMS);
>         autocfg = dw_params >> DW_PARAMS_EN & 0x1;
>
> +       if (!pdata && autocfg)
> +               pdata = &dw_dma_pdata;

Allocate it dynamically to support multiple controllers with different
configuration
in a SoC.
