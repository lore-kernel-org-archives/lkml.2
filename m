Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab2GMMvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:51:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41174 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2GMMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <1342095778-13403-3-git-send-email-stigge@antcom.de>
References: <1342095778-13403-1-git-send-email-stigge@antcom.de>
	<1342095778-13403-3-git-send-email-stigge@antcom.de>
Date: Fri, 13 Jul 2012 09:51:29 -0300
Message-ID: <CAAAP30GxeXHfeZZchYzSjBQXfkS+o+sabAU5iy8uBxiSoO87hQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd: lpc32xx_mlc: Adjust to pl08x DMA interface changes
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 9:22 AM, Roland Stigge <stigge@antcom.de> wrote:
> This patch adjusts the LPC32xx MLC NAND driver to the new pl08x DMA interface,
> fixing the compile error resulting from changed pl08x structures.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-By: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>
> Applies to today's linux-next (integrated lpc32xx-next and dma branches which collide)
>
>  drivers/mtd/nand/lpc32xx_mlc.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
> index 260b2c2..1cf3593 100644
> --- a/drivers/mtd/nand/lpc32xx_mlc.c
> +++ b/drivers/mtd/nand/lpc32xx_mlc.c
> @@ -576,17 +576,6 @@ static void lpc32xx_ecc_enable(struct mtd_info *mtd, int mode)
>         /* Always enabled! */
>  }
>
> -static bool lpc32xx_dma_filter(struct dma_chan *chan, void *param)
> -{
> -       struct pl08x_dma_chan *ch =
> -               container_of(chan, struct pl08x_dma_chan, chan);
> -
> -       /* In LPC32xx's PL080 DMA wiring, the MLC NAND DMA signal is #12 */
> -       if (ch->cd->min_signal == 12)
> -               return true;
> -       return false;
> -}
> -
>  static int lpc32xx_dma_setup(struct lpc32xx_nand_host *host)
>  {
>         struct mtd_info *mtd = &host->mtd;
> @@ -594,7 +583,7 @@ static int lpc32xx_dma_setup(struct lpc32xx_nand_host *host)
>
>         dma_cap_zero(mask);
>         dma_cap_set(DMA_SLAVE, mask);
> -       host->dma_chan = dma_request_channel(mask, lpc32xx_dma_filter, NULL);
> +       host->dma_chan = dma_request_channel(mask, pl08x_filter_id, "nand-mlc");
>         if (!host->dma_chan) {
>                 dev_err(mtd->dev.parent, "Failed to request DMA channel\n");
>                 return -EBUSY;
> --
> 1.7.10.4
>
