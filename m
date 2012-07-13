Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2GMI0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:26:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44225 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab2GMI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 13 Jul 2012 09:26:32 +0100
X-Google-Sender-Auth: p7K4CG7L5LjsTCaL6lq1BeK8iIQ
Message-ID: <CAOh2x=k6MDt5arZfPgrn8_tPu_zgPsD2e5y0-JyUkrx71Z6BNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] dw_dmac: set default alignment
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to keep spear-devel in cc, as this is the second
platform that uses this driver.

On Fri, Jul 13, 2012 at 9:09 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The default values are filled to support at least mem-to-mem tests provided by
> dmatest module. It makes sense to choose the 4 bytes (2 least significant bits)
> alignment by the default.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 3d061c6..2a19ab6 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1485,6 +1485,12 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         dw->dma.device_tx_status = dwc_tx_status;
>         dw->dma.device_issue_pending = dwc_issue_pending;
>
> +       /* Set default alignment */
> +       dw->dma.copy_align = 2;
> +       dw->dma.xor_align = 2;
> +       dw->dma.pq_align = 2;
> +       dw->dma.fill_align = 2;

To understand it more, what does this mean? We will not support
transfers with unaligned
addresses/length to word size?

--
viresh
