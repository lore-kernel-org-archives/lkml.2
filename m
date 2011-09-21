Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1IUTJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:09:24 -0400
Received: from imr4.ericy.com ([198.24.6.9]:54860 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1IUTJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:09:23 -0400
Date: Wed, 21 Sep 2011 12:07:45 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Yong Zhang <yong.zhang0@gmail.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 56/57] hwmon: irq: Remove IRQF_DISABLED
Message-ID: <20110921190745.GA30759@ericsson.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-57-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316597339-29861-57-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:28:57AM -0400, Yong Zhang wrote:
> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/hwmon/exynos4_tmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/exynos4_tmu.c b/drivers/hwmon/exynos4_tmu.c
> index 0170c90..faa0884 100644
> --- a/drivers/hwmon/exynos4_tmu.c
> +++ b/drivers/hwmon/exynos4_tmu.c
> @@ -394,7 +394,7 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
>  	}
>  
>  	ret = request_irq(data->irq, exynos4_tmu_irq,
> -		IRQF_DISABLED | IRQF_TRIGGER_RISING,
> +		IRQF_TRIGGER_RISING,
>  		"exynos4-tmu", data);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
> -- 

Applied.

Thanks,
Guenter
