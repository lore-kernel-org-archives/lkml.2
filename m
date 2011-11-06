Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1KFQNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:13:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36304 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1KFQNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:13:45 -0500
MIME-Version: 1.0
In-Reply-To: <1320426984-17525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1320426984-17525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sun, 6 Nov 2011 21:43:45 +0530
Message-ID: <CAJuYYwQakbLqM46gVexB4Evby-aHA11hAx4N4Nw4mdYXp_yEOQ@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: Fix build for non-Exynos4210 devices
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 4 November 2011 22:46, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> exynos4120_serial_drv_data is only defined when building with support
> for Exynos4210 so use the already provided define to ensure that we
> don't reference it when building for other SoCs.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I missed that one. Thanks for the fix.

The Samsung device tree patches will not be merged in v3.2 merge
window. So should this fix be merged into the uart dt support patch or
should this be a separate patch?

Thanks,
Thomas.

> ---
>  drivers/tty/serial/samsung.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index efe3756..7272eee 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -1649,7 +1649,7 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_serial_driver_ids);
>  #ifdef CONFIG_OF
>  static const struct of_device_id s3c24xx_uart_dt_match[] = {
>        { .compatible = "samsung,exynos4210-uart",
> -               .data = &exynos4210_serial_drv_data },
> +               .data = EXYNOS4210_SERIAL_DRV_DATA },
>        {},
>  };
>  MODULE_DEVICE_TABLE(of, s3c24xx_uart_dt_match);
> --
> 1.7.7.1
>
>
