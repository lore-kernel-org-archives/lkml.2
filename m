Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2ICK5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 06:57:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61078 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2ICK5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 06:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <1346669179-21024-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1346669179-21024-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 3 Sep 2012 16:27:35 +0530
X-Google-Sender-Auth: g8D3w2eWS1odpF4dopFn7-37e-o
Message-ID: <CAOh2x=nrmQafH72rSE5m0ny1pU435z0Hkghpj1r=Tw3-O1-94g@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: utilize slave_id to pass request line
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 4:16 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There is slave_id field in the generic slave config structure that is dedicated
> for the uniq slave number. In our case we have the request lines wired to the
> certain hardware. Therefore the number of the request line is uniq and could be
> used as slave_id. It allows us in some cases to drop out the usage of the
> custom slave config structure.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index f0c9403..7a67673 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -187,6 +187,11 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
>
>                 cfghi = dws->cfg_hi;
>                 cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
> +       } else {
> +               if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
> +                       cfghi = DWC_CFGH_DST_PER(dwc->dma_sconfig.slave_id);
> +               else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
> +                       cfghi = DWC_CFGH_SRC_PER(dwc->dma_sconfig.slave_id);
>         }
>
>         channel_writel(dwc, CFG_LO, cfglo);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
