Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1AYPOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:14:40 -0500
Received: from service87.mimecast.com ([94.185.240.25]:58216 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751772Ab1AYPOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:14:39 -0500
Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
 re-enabling l2x0
From: Catalin Marinas <catalin.marinas@arm.com>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net, konkers@android.com,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1295834493-5019-5-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	 <1295834493-5019-5-git-send-email-ccross@android.com>
Organization: ARM Limited
Date: Tue, 25 Jan 2011 15:14:24 +0000
Message-ID: <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 Jan 2011 15:14:30.0269 (UTC) FILETIME=[90595AD0:01CBBCA2]
X-MC-Unique: 111012515143411701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 02:01 +0000, Colin Cross wrote:
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -252,16 +252,26 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
>         spin_unlock_irqrestore(&l2x0_lock, flags);
>  }
> 
> +/* enables l2x0 after l2x0_disable, does not invalidate */
> +void l2x0_enable(void)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&l2x0_lock, flags);
> +       writel_relaxed(1, l2x0_base + L2X0_CTRL);
> +       spin_unlock_irqrestore(&l2x0_lock, flags);
> +}
> +
>  static void l2x0_disable(void)
>  {
>         unsigned long flags;
> 
>         spin_lock_irqsave(&l2x0_lock, flags);
> -       writel(0, l2x0_base + L2X0_CTRL);
> +       writel_relaxed(0, l2x0_base + L2X0_CTRL);
>         spin_unlock_irqrestore(&l2x0_lock, flags);
>  }
> 
> -void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
> +void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
>  {
>         __u32 aux;
>         __u32 cache_id;

So this assumes that the L2 registers are accessible. I suspect the
platform code calling it should know this.

The patch looks fine.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>


