Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2FRGba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:31:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38974 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2FRGb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:31:28 -0400
MIME-Version: 1.0
In-Reply-To: <1339665743-7947-1-git-send-email-sonic.adi@gmail.com>
References: <1339665743-7947-1-git-send-email-sonic.adi@gmail.com>
Date: Mon, 18 Jun 2012 14:31:26 +0800
Message-ID: <CAJxxZ0OARrRmYZZcwSSi-hEEb6B39wOTA26WT1gtfWfipR+=3A@mail.gmail.com>
Subject: Re: [PATCH 1/5 v2] mmc: bfin_sdh: limit mmc DMA segment len to 1 for bf518.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Could you please comment on the patches for blackfin SD controller driver?

Thanks

Sonic

On Thu, Jun 14, 2012 at 5:22 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> bf518 RSI dma doesn't work in array mode.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/mmc/host/bfin_sdh.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
> index 0366617..fd25b0c 100644
> --- a/drivers/mmc/host/bfin_sdh.c
> +++ b/drivers/mmc/host/bfin_sdh.c
> @@ -469,7 +469,11 @@ static int __devinit sdh_probe(struct platform_device *pdev)
>        }
>
>        mmc->ops = &sdh_ops;
> +#if defined(CONFIG_BF54x)
>        mmc->max_segs = 32;
> +#elif defined(CONFIG_BF51x)
> +       mmc->max_segs = 1;
> +#endif
>        mmc->max_seg_size = 1 << 16;
>        mmc->max_blk_size = 1 << 11;
>        mmc->max_blk_count = 1 << 11;
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
