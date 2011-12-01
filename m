Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1LANEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:04:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44570 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1LAND7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:03:59 -0500
MIME-Version: 1.0
In-Reply-To: <1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
	<1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
Date: Thu, 1 Dec 2011 14:03:58 +0100
Message-ID: <CACRpkdY5_kDf2C=85cuNYya6_eeRbZ4Uu5FKQ2a76N=r8gtAtw@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: dbx500: convert to clocksource_register_hz()
From: Linus Walleij <linus.walleij@linaro.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 8:20 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:

> Convert clocksource_dbx500_prcmu to use clocksource_register_hz.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mattias Wallin <mattias.wallin@stericsson.com>
> ---
>  drivers/clocksource/clksrc-dbx500-prcmu.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
> index 59feefe..74e8901 100644
> --- a/drivers/clocksource/clksrc-dbx500-prcmu.c
> +++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
> @@ -52,7 +52,6 @@ static struct clocksource clocksource_dbx500_prcmu = {
>        .name           = "dbx500-prcmu-timer",
>        .rating         = 300,
>        .read           = clksrc_dbx500_prcmu_read,
> -       .shift          = 10,
>        .mask           = CLOCKSOURCE_MASK(32),
>        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
>  };
> @@ -100,7 +99,5 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
>        init_sched_clock(&cd, clksrc_dbx500_prcmu_update_sched_clock,
>                         32, RATE_32K);
>  #endif
> -       clocksource_calc_mult_shift(&clocksource_dbx500_prcmu,
> -                                   RATE_32K, SCHED_CLOCK_MIN_WRAP);
> -       clocksource_register(&clocksource_dbx500_prcmu);
> +       clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
>  }
> --
> 1.7.5.4

Looks good,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
