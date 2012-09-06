Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2IFPnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:43:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36954 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257Ab2IFPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:43:46 -0400
MIME-Version: 1.0
In-Reply-To: <1346944864-12434-1-git-send-email-djkurtz@chromium.org>
References: <1346944864-12434-1-git-send-email-djkurtz@chromium.org>
Date: Thu, 6 Sep 2012 08:43:45 -0700
X-Google-Sender-Auth: KFuT2zU2wVJqNAP5PN31tE7txXg
Message-ID: <CAD=FV=UTa4a8wewEdqu=ZnOKe-M5Brv-ex8ZGWfkTb6fqsRB_w@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: no duplicate mask/unmask in eint0_15
From: Doug Anderson <dianders@chromium.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>, olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 8:21 AM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> chained_irq_enter/exit() already mask&ack/unmask the chained interrupt.
> There is no need to also explicitly do it in the handler.
>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  arch/arm/mach-exynos/common.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index 4eb39cd..0a85aec 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -965,14 +965,7 @@ static void exynos_irq_eint0_15(unsigned int irq, struct irq_desc *desc)
>         struct irq_chip *chip = irq_get_chip(irq);
>
>         chained_irq_enter(chip, desc);
> -       chip->irq_mask(&desc->irq_data);
> -
> -       if (chip->irq_ack)
> -               chip->irq_ack(&desc->irq_data);
> -
>         generic_handle_irq(*irq_data);
> -
> -       chip->irq_unmask(&desc->irq_data);
>         chained_irq_exit(chip, desc);
>  }
>
> --
> 1.7.7.3
>

Acked-by: Doug Anderson <dianders@chromium.org>
