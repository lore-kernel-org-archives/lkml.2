Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2IRGjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:39:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62818 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2IRGjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:09:01 +0530
X-Google-Sender-Auth: 1baWs8jJN1pg9fH_sDfPKAPNJOc
Message-ID: <CAOh2x==Te7MBNrqX-wjaPzso_xTC44rUejMDhs7SW7HJag7j8g@mail.gmail.com>
Subject: Re: [PATCH 2/7] dw_dmac: fill optional encoded parameters in register structure
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index f6d92d7..4633d39 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -82,9 +82,28 @@ struct dw_dma_regs {
>         DW_REG(ID);
>         DW_REG(TEST);
>
> +       /* reserved */
> +       DW_REG(__reserved0);
> +       DW_REG(__reserved1);
> +
>         /* optional encoded params, 0x3c8..0x3f7 */
> +       u32     __reserved;
> +
> +       /* per-channel configuration registers */
> +       u32     DWC_PARAMS[DW_DMA_MAX_NR_CHANNELS];
> +       u32     MULTI_BLK_TYPE;
> +       u32     MAX_BLK_SIZE;
> +
> +       /* top-level parameters */
> +       u32     DW_PARAMS;
>  };

Above is Ok.

> +#define dma_raw_readl(addr, name) \
> +       readl((addr) + offsetof(struct dw_dma_regs, name))
> +
> +#define dma_raw_writel(addr, name, val) \
> +       writel((val), (addr) + offsetof(struct dw_dma_regs, name))
> +

But why don't you use earlier defined readl/writel macros:
dma_readl and dma_writel?

--
viresh
