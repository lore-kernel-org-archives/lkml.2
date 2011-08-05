Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1HEKUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:20:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63984 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1HEKUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <1312515303-17169-1-git-send-email-tgih.jun@samsung.com>
References: <1312515303-17169-1-git-send-email-tgih.jun@samsung.com>
Date: Fri, 5 Aug 2011 11:20:42 +0100
Message-ID: <CAFbHwiT3p3pSC1q4xQRYkLzSG7tPuGLXB4KKwC-8HWMmtF+fhA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Fix DDR mode support.
From: Will Newton <will.newton@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 4:35 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Host driver can't get a hint of DDR mode through ios->ddr flag anymore.
> ios->timing is currently used to inform DDR mode as a substitute.
> And capability of MMC_CAP_MMC_HIGHSPEED is added for DDR support.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/mmc/host/dw_mmc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index d65511e..b412a1d 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -699,7 +699,7 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>        }
>
>        /* DDR mode set */
> -       if (ios->ddr) {
> +       if (ios->timing == MMC_TIMING_UHS_DDR50) {
>                regs = mci_readl(slot->host, UHS_REG);
>                regs |= (0x1 << slot->id) << 16;
>                mci_writel(slot->host, UHS_REG, regs);
> @@ -1646,7 +1646,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>                        mmc->caps |= MMC_CAP_4_BIT_DATA;
>
>        if (host->pdata->quirks & DW_MCI_QUIRK_HIGHSPEED)
> -               mmc->caps |= MMC_CAP_SD_HIGHSPEED;
> +               mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
>
>  #ifdef CONFIG_MMC_DW_IDMAC
>        mmc->max_segs = host->ring_size;
> --
> 1.7.0.4

Acked-by: Will Newton <will.newton@imgtec.com>
