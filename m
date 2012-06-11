Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2FKOiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:38:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47411 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2FKOiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <1339198902.15067.1.camel@phoenix>
References: <1339198902.15067.1.camel@phoenix>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 11 Jun 2012 22:37:38 +0800
X-Google-Sender-Auth: XoVzyVHzaHudtP9PRDphB-iSdck
Message-ID: <CAK5ve-Ksf1k_zZHBW64y4nRd3nr-ysxZ5jyKRtu0D1APuEms0A@mail.gmail.com>
Subject: Re: [PATCH] leds: Make LEDS_ASIC3 and LEDS_RENESAS_TPU depend on LEDS_CLASS=y
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
        Paul Parsons <lost.distance@yahoo.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 7:41 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Otherwise, I got below build error when CONFIG_LEDS_CLASS=m.
>
>  LD      init/built-in.o
> drivers/built-in.o: In function `asic3_led_probe':
> clkdev.c:(.devinit.text+0x4680): undefined reference to `led_classdev_register'
> drivers/built-in.o: In function `r_tpu_probe':
> clkdev.c:(.devinit.text+0x4838): undefined reference to `led_classdev_register'
> drivers/built-in.o: In function `asic3_led_remove':
> clkdev.c:(.devexit.text+0x564): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `r_tpu_remove':
> clkdev.c:(.devexit.text+0x5a0): undefined reference to `led_classdev_unregister'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Good, applied to my fixes-for-3.5 branch.

Thanks
-Bryan

> ---
>  drivers/leds/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 04cb8c8..12b2b55 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -379,7 +379,7 @@ config LEDS_NETXBIG
>
>  config LEDS_ASIC3
>        bool "LED support for the HTC ASIC3"
> -       depends on LEDS_CLASS
> +       depends on LEDS_CLASS=y
>        depends on MFD_ASIC3
>        default y
>        help
> @@ -390,7 +390,7 @@ config LEDS_ASIC3
>
>  config LEDS_RENESAS_TPU
>        bool "LED support for Renesas TPU"
> -       depends on LEDS_CLASS && HAVE_CLK && GENERIC_GPIO
> +       depends on LEDS_CLASS=y && HAVE_CLK && GENERIC_GPIO
>        help
>          This option enables build of the LED TPU platform driver,
>          suitable to drive any TPU channel on newer Renesas SoCs.
> --
> 1.7.9.5
>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
