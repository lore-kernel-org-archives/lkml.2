Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2IRHNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:13:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34968 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2IRHNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-7-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:43:49 +0530
X-Google-Sender-Auth: 7AyfQn9qg2rLccot30_z424IK_A
Message-ID: <CAOh2x=mav-8hkKEpOw0H5vQ=uPx+7sxBPsa_eDpTpEqgXuzXSQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] dw_dmac: check if controller supports LLP
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
> Some controllers have the reduced functionality where the LLP multi block
> transfers are not supported. This patch introduces a check and refuses to deal
> with such devices.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c      |   35 ++++++++++++++++++++++++++++++++++-
>  drivers/dma/dw_dmac_regs.h |    4 ++++
>  2 files changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index fdb7d5a..00958ad 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -647,6 +647,12 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>         unsigned int            dst_width;
>         u32                     ctllo;
>
> +       if (dwc->nollp) {
> +               dev_dbg(chan2dev(&dwc->chan),
> +                               "channel doesn't support LLP transfers\n");
> +               return NULL;
> +       }

But this could have been a single block request. Isn't it?

--
viresh
