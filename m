Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2KPODl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:03:41 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53715 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2KPODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:03:39 -0500
MIME-Version: 1.0
In-Reply-To: <1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 16 Nov 2012 19:33:39 +0530
Message-ID: <CAKohpo=nA01_K5sD-7k7VENW222GRvvY-MytTb2Bur04mh5T6g@mail.gmail.com>
Subject: Re: [PATCH 1/6] dmaengine: introduce is_slave_xfer function
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2012 19:29, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This function helps to distinguish the slave type of transfer by checking the
> direction parameter.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/dmaengine.h |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 6402b18..3e1a9026 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -618,6 +618,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>                         (unsigned long)config);
>  }
>
> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
> +{
> +       return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
> +}

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

Though i still have vote to include DMA_DEV_TO_DEV in thist list :)
