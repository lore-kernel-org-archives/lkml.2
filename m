Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2B0Xu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:50:28 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:34525 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672Ab2B0Xu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:50:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of khilman@ti.com designates 10.68.72.70 as permitted sender) smtp.mail=khilman@ti.com
From: Kevin Hilman <khilman@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: <linux-omap@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] gpio/omap: remove saved_wakeup field from struct gpio_bank
Organization: Texas Instruments, Inc.
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
	<1329999031-6914-3-git-send-email-tarun.kanti@ti.com>
Date: Mon, 27 Feb 2012 15:50:24 -0800
In-Reply-To: <1329999031-6914-3-git-send-email-tarun.kanti@ti.com> (Tarun
	Kanti DebBarma's message of "Thu, 23 Feb 2012 17:40:27 +0530")
Message-ID: <87aa43vnsv.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarun Kanti DebBarma <tarun.kanti@ti.com> writes:

> There is no more need to have saved_wakeup. Instead we can use
> context.wake_en which holds the current wakeup enable register
> context. This also means that the read from wakeup enable register
> is not needed.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Looks right, but one question below...

> ---
>  drivers/gpio/gpio-omap.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 40a1fb2..64f15d5 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -54,7 +54,6 @@ struct gpio_bank {
>  	u16 irq;
>  	u16 virtual_irq_start;
>  	u32 suspend_wakeup;
> -	u32 saved_wakeup;
>  	u32 non_wakeup_gpios;
>  	u32 enabled_non_wakeup_gpios;
>  	struct gpio_regs context;
> @@ -772,7 +771,7 @@ static int omap_mpuio_suspend_noirq(struct device *dev)
>  	unsigned long		flags;
>  
>  	spin_lock_irqsave(&bank->lock, flags);
> -	bank->saved_wakeup = __raw_readl(mask_reg);
> +	bank->context.wake_en = __raw_readl(mask_reg);

Why is this read needed?

Kevin

>  	__raw_writel(0xffff & ~bank->suspend_wakeup, mask_reg);
>  	spin_unlock_irqrestore(&bank->lock, flags);
>  
