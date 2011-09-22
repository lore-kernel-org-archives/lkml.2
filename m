Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1IVOus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:50:48 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44045 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab1IVOup convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:50:45 -0400
MIME-Version: 1.0
In-Reply-To: <1316597339-29861-38-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com> <1316597339-29861-38-git-send-email-yong.zhang0@gmail.com>
From: "Kadiyala, Kishore" <kishore.kadiyala@ti.com>
Date: Thu, 22 Sep 2011 20:20:23 +0530
Message-ID: <CAA93xcbHJNpPsPetnLZbPiJ+36QBr8cHFwOdv=yCOVgY9LjgFw@mail.gmail.com>
Subject: Re: [PATCH 37/57] mmc: irq: Remove IRQF_DISABLED
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, Balaji T K <balajitk@ti.com>,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 2:58 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
>
> So now this flag is a NOOP and can be removed.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

For omap_hsmmc.c

Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>

> ---
>  drivers/mmc/host/omap_hsmmc.c |    5 ++---
>  drivers/mmc/host/tmio_mmc.c   |    4 ++--
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 21e4a79..75c6395 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2015,7 +2015,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
>        }
>
>        /* Request IRQ for MMC operations */
> -       ret = request_irq(host->irq, omap_hsmmc_irq, IRQF_DISABLED,
> +       ret = request_irq(host->irq, omap_hsmmc_irq, 0,
>                        mmc_hostname(mmc), host);
>        if (ret) {
>                dev_dbg(mmc_dev(host->mmc), "Unable to grab HSMMC IRQ\n");
> @@ -2043,8 +2043,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
>        if ((mmc_slot(host).card_detect_irq)) {
>                ret = request_irq(mmc_slot(host).card_detect_irq,
>                                  omap_hsmmc_cd_handler,
> -                                 IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
> -                                         | IRQF_DISABLED,
> +                                 IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>                                  mmc_hostname(mmc), host);
>                if (ret) {
>                        dev_dbg(mmc_dev(host->mmc),
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index 44a9668..a4ea102 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -88,8 +88,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *pdev)
>        if (ret)
>                goto cell_disable;
>
> -       ret = request_irq(irq, tmio_mmc_irq, IRQF_DISABLED |
> -                         IRQF_TRIGGER_FALLING, dev_name(&pdev->dev), host);
> +       ret = request_irq(irq, tmio_mmc_irq, IRQF_TRIGGER_FALLING,
> +                               dev_name(&pdev->dev), host);
>        if (ret)
>                goto host_remove;
>
> --
> 1.7.4.1
>
>
