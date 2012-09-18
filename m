Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2IRGfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:35:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48404 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2IRGfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <1347939042.15578.1.camel@phoenix>
References: <1347939042.15578.1.camel@phoenix>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 18 Sep 2012 14:34:48 +0800
X-Google-Sender-Auth: ert8SNFJG6euAPsBvZiW4tH7zDw
Message-ID: <CAK5ve-LXv76vuBLHQQtREHn_ZogUsbyqzz2-uTHT_Ps-9vS3Pw@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP: OMAP_DEBUG_LEDS needs to select LEDS_CLASS
To: Axel Lin <axel.lin@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:30 AM, Axel Lin <axel.lin@gmail.com> wrote:
> This fixes below build error when CONFIG_LEDS_CLASS is not set.
>
>   LD      init/built-in.o
> arch/arm/plat-omap/built-in.o: In function `fpga_probe':
> arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
> make: *** [vmlinux] Error 1
>

Thanks for posting this. But I think Tony has already fixed it in mainline:
--
commit 359f64f7b3997e94ee71039b5fcdc1278b9b77c4
Author: Tony Lindgren <tony@atomide.com>
Date:   Wed Sep 15 10:18:51 2010 -0700

    omap: Fix compile dependency to LEDS_CLASS

    If we LEDS_CLASS is not selected, we will get undefined reference
    to `led_classdev_register'.

    Signed-off-by: Tony Lindgren <tony@atomide.com>
--

-Bryan

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/plat-omap/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index ca83a76..c262781 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -43,6 +43,7 @@ config OMAP_DEBUG_DEVICES
>
>  config OMAP_DEBUG_LEDS
>         def_bool y if NEW_LEDS
> +       select LEDS_CLASS
>         depends on OMAP_DEBUG_DEVICES
>
>  config POWER_AVS_OMAP
> --
> 1.7.9.5
>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
