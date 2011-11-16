Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1KPKd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:33:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59965 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1KPKdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:33:55 -0500
MIME-Version: 1.0
In-Reply-To: <1321433173-17757-1-git-send-email-mad_soft@inbox.ru>
References: <1321433173-17757-1-git-send-email-mad_soft@inbox.ru>
Date: Wed, 16 Nov 2011 16:03:54 +0530
Message-ID: <CAJuYYwTv3d9Wg8TDBEkc0r3BweUiLdqVwGdMU4iKpK0B+EM=GA@mail.gmail.com>
Subject: Re: [PATCH] watchdog: fix initialisation printout in s3c2410_wdt
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2011 14:16, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> Looks like a typo creeped in, and driver prints
> s3c2410-wdt s3c2410-wdt: watchdog active, reset abled, irq abled
>
> instead of
> s3c2410-wdt s3c2410-wdt: watchdog active, reset enabled, irq enabled
>
> Also it may completely disinform about irq status, as it prints
> "irq enabled" when S3C2410_WTCON_INTEN is in fact 0.
>
> Fix it.
>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
>
> It seems to be here for a long time, but I don't think it's
> important enough for cc-ing stable.
>
> Also I haven't tested it, as I don't have a hardware, but it's
> rather trivial (and yes, I checked with datasheet that 1 in
> S3C2410_WTCON_*EN bits really means 'enabled')
>

Tested on Exynos4210 based Origen board. This patch fixed in incorrect
"irq enabled" message at bootup. Thanks for this fix.

Tested-by: Thomas Abraham <thomas.abraham@linaro.org>

>  drivers/watchdog/s3c2410_wdt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
> index 5de7e4f..a79e384 100644
> --- a/drivers/watchdog/s3c2410_wdt.c
> +++ b/drivers/watchdog/s3c2410_wdt.c
> @@ -401,8 +401,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
>
>        dev_info(dev, "watchdog %sactive, reset %sabled, irq %sabled\n",
>                 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
> -                (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
> -                (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
> +                (wtcon & S3C2410_WTCON_RSTEN) ? "en" : "dis",
> +                (wtcon & S3C2410_WTCON_INTEN) ? "en" : "dis");
>
>        return 0;
>
> --
> 1.7.5.1.300.gc565c
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
