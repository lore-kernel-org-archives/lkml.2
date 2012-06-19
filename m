Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2FSKjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:39:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47845 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2FSKjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <1340102050-12697-11-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1340102050-12697-11-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 19 Jun 2012 11:39:39 +0100
Message-ID: <CAOh2x=k024nEQ3_K03YTFw+inWerB3N+Tjvwh8RiqYA4qSieOg@mail.gmail.com>
Subject: Re: [PATCHv2 10/10] dw_dmac: introduce dwc_chan_reset
From: viresh kumar <viresh.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:34 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This piece of code is used often. Make it as a separate function.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d3845ef..14fbee4 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -219,6 +219,14 @@ static void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
>                channel_readl(dwc, CTL_LO));
>  }
>
> +
> +static inline void dwc_chan_reset(struct dw_dma *dw, struct dw_dma_chan *dwc)
> +{
> +       channel_clear_bit(dw, CH_EN, dwc->mask);
> +       while (dma_readl(dw, CH_EN) & dwc->mask)
> +               cpu_relax();
> +}

Hmm... This is not really a reset but disable.

Can you consider naming it more closer to what it is doing?

--
viresh
