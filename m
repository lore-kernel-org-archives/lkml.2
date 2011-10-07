Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab1JGGMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:12:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38831 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1JGGMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-11-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-11-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 14:12:24 +0800
Message-ID: <CAMPhdO_SMG8QK8jrV4dYpCRdWy_21Cj1v85Rq+7Tss6Z+3g_QA@mail.gmail.com>
Subject: Re: [PATCH 10/26] ARM: pxa: allow selecting just one of TREO680/CENTRO
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> There are two variants of the palmtreo machine, the 680 and the
> centro, and Kconfig allows selecting one or both of them.
> This changes the board file so that it's actually possible
> to build all configurations that are allowed.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good to me. Applied.

Cc'ed Marek Vasut.

> ---
>  arch/arm/mach-pxa/palmtreo.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/palmtreo.c b/arch/arm/mach-pxa/palmtreo.c
> index bb27d4b..30364b0 100644
> --- a/arch/arm/mach-pxa/palmtreo.c
> +++ b/arch/arm/mach-pxa/palmtreo.c
> @@ -423,6 +423,7 @@ static void __init palmphone_common_init(void)
>        palmtreo_leds_init();
>  }
>
> +#ifdef CONFIG_MACH_TREO680
>  static void __init treo680_init(void)
>  {
>        pxa2xx_mfp_config(ARRAY_AND_SIZE(treo680_pin_config));
> @@ -430,7 +431,9 @@ static void __init treo680_init(void)
>        palm27x_mmc_init(GPIO_NR_TREO_SD_DETECT_N, GPIO_NR_TREO680_SD_READONLY,
>                        GPIO_NR_TREO680_SD_POWER, 0);
>  }
> +#endif
>
> +#ifdef CONFIG_MACH_CENTRO
>  static void __init centro_init(void)
>  {
>        pxa2xx_mfp_config(ARRAY_AND_SIZE(centro685_pin_config));
> @@ -438,7 +441,9 @@ static void __init centro_init(void)
>        palm27x_mmc_init(GPIO_NR_TREO_SD_DETECT_N, -1,
>                        GPIO_NR_CENTRO_SD_POWER, 1);
>  }
> +#endif
>
> +#ifdef CONFIG_MACH_TREO680
>  MACHINE_START(TREO680, "Palm Treo 680")
>        .boot_params    = 0xa0000100,
>        .map_io         = pxa27x_map_io,
> @@ -448,7 +453,9 @@ MACHINE_START(TREO680, "Palm Treo 680")
>        .timer          = &pxa_timer,
>        .init_machine   = treo680_init,
>  MACHINE_END
> +#endif
>
> +#ifdef CONFIG_MACH_CENTRO
>  MACHINE_START(CENTRO, "Palm Centro 685")
>        .boot_params    = 0xa0000100,
>        .map_io         = pxa27x_map_io,
> @@ -458,3 +465,4 @@ MACHINE_START(CENTRO, "Palm Centro 685")
>        .timer          = &pxa_timer,
>        .init_machine   = centro_init,
>  MACHINE_END
> +#endif
> --
> 1.7.5.4
>
>
