Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2GMI10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:27:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37589 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab2GMI1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <1342166974-4490-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1342166974-4490-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 13 Jul 2012 09:27:20 +0100
X-Google-Sender-Auth: a2D6-wuj5DLRmbujkNnEN-GSHyM
Message-ID: <CAOh2x=kkjgPx0Bd7JLgDm+wkCXoWc7Ti2Eq8DXkDepV2nDyp_A@mail.gmail.com>
Subject: Re: [PATCH 2/3] dw_dmac: use 'u32' for LLI structure members, not dma_addr_t
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 9:09 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Use 'u32' for the LLI structure members, which are defined by hardware to be
> 32-bit. dma_addr_t is much more vague about its actual size.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c      |    7 ++-----
>  drivers/dma/dw_dmac_regs.h |    6 +++---
>  2 files changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index db56ef4..3d061c6 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -416,11 +416,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
>  static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
>  {
>         dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> -                       "  desc: s0x%llx d0x%llx l0x%llx c0x%x:%x\n",
> -                       (unsigned long long)lli->sar,
> -                       (unsigned long long)lli->dar,
> -                       (unsigned long long)lli->llp,
> -                       lli->ctlhi, lli->ctllo);
> +                       "  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
> +                       lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
>  }
>
>  static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index e248481..50830be 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -219,9 +219,9 @@ static inline struct dw_dma *to_dw_dma(struct dma_device *ddev)
>  /* LLI == Linked List Item; a.k.a. DMA block descriptor */
>  struct dw_lli {
>         /* values that are not changed by hardware */
> -       dma_addr_t      sar;
> -       dma_addr_t      dar;
> -       dma_addr_t      llp;            /* chain to next lli */
> +       u32             sar;
> +       u32             dar;
> +       u32             llp;            /* chain to next lli */
>         u32             ctllo;
>         /* values that may get written back: */
>         u32             ctlhi;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
