Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2ENMEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:04:42 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:47645 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124Ab2ENMEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:04:40 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 08:04:40 EDT
MIME-Version: 1.0
In-Reply-To: <1336984792-13956-1-git-send-email-yongd@marvell.com>
References: <1336984792-13956-1-git-send-email-yongd@marvell.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Mon, 14 May 2012 17:27:24 +0530
Message-ID: <CANfBPZ_hgEks_dTBWomaj49xLiXaz-_x+rCAYjCgLQNa24WU=A@mail.gmail.com>
Subject: Re: [PATCH] mmc:sdio:retry CMD52/53 when error happens
To: yongd <yongd@marvell.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org,
        stefan.xk.nilsson@stericsson.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 2:09 PM, yongd <yongd@marvell.com> wrote:
>  Set sdio CMD52/53's retry time as MMC_CMD_RETRIES. As a result,
> sdio might benefit from core-internal CMD retry mechanism when
> some errors happen(CRC, etc).
>
> Signed-off-by: yongd <yongd@marvell.com>
> ---
>  drivers/mmc/core/sdio_ops.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index d29e206..884c27e 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -86,7 +86,7 @@ static int mmc_io_rw_direct_host(struct mmc_host *host, int write, unsigned fn,
>        cmd.arg |= in;
>        cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC;
>
> -       err = mmc_wait_for_cmd(host, &cmd, 0);
> +       err = mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
>        if (err)
>                return err;
>
> @@ -147,6 +147,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>        else
>                cmd.arg |= 0x08000000 | blocks;         /* block mode */
>        cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
> +       cmd.retries = MMC_CMD_RETRIES;
>
>        data.blksz = blksz;
>        /* Code in host drivers/fwk assumes that "blocks" always is >=1 */
> --

Looks right to me.
Reviewed-by: Venkatraman S <svenkatr@ti.com>
