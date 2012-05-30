Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2E3HKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:10:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37582 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2E3HK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <1338353260-10097-17-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
	<1338353260-10097-17-git-send-email-lee.jones@linaro.org>
Date: Wed, 30 May 2012 15:10:28 +0800
Message-ID: <CACRpkdYZaxW52dWwGzEo-7yV31dW_U37xUP2TM4G+Dz=dJ8EKw@mail.gmail.com>
Subject: Re: [PATCH 16/22] mfd: ab8500-gpadc: Enable IRQF_ONESHOT when
 requesting a threaded IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Arun MURTHY <arun.murthy@stericsson.com>,
        Kalle Komierowski <karl.komierowski@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 12:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-gpadc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
> index c39fc71..358d502 100644
> --- a/drivers/mfd/ab8500-gpadc.c
> +++ b/drivers/mfd/ab8500-gpadc.c
> @@ -599,7 +599,8 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
>        /* Register interrupt  - SwAdcComplete */
>        ret = request_threaded_irq(gpadc->irq, NULL,
>                ab8500_bm_gpswadcconvend_handler,
> -               IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc", gpadc);
> +               IRQF_ONESHOT | IRQF_NO_SUSPEND | IRQF_SHARED,
> +                               "ab8500-gpadc", gpadc);

Looks correct to me I think this one should be ONESHOT anyway.

Yours,
Linus Walleij
