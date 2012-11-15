Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768144Ab2KOO6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:58:05 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42373 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768119Ab2KOO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 15 Nov 2012 20:28:02 +0530
X-Google-Sender-Auth: m3-am-SnFOq-XONn2ztNWYiG5d4
Message-ID: <CAOh2x=mpzinz4xr4poNtX0Mom65kfptGM047-hu+XDLTS7m2rw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 7:50 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

> +static inline bool dwc_is_slave(struct dma_slave_config *sconfig)
> +{
> +       return is_slave_direction(sconfig->direction);
> +}

I will not buy this one. Why hide the real implementation, call
is_slave_direction()
directly.

> @@ -1344,6 +1352,8 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
> +       sconfig->direction = direction;
> +

> @@ -1718,6 +1728,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
> +               dwc->dma_sconfig.direction = DMA_TRANS_NONE;

Why do you need above changes??

--
viresh
