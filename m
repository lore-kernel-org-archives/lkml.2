Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2LRB1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:27:24 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:49972 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab2LRB1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:27:23 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 20:27:23 EST
MIME-Version: 1.0
In-Reply-To: <1355774107-364-2-git-send-email-tobetter@gmail.com>
References: <1355774107-364-1-git-send-email-tobetter@gmail.com>
	<1355774107-364-2-git-send-email-tobetter@gmail.com>
Date: Mon, 17 Dec 2012 19:22:16 -0600
Message-ID: <CAJuYYwSOznu772g9h-5JMQ8DwWR-Oohx=ugLsX0DHxDhS8icKA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ODROID-X: dts: Add board dts file for ODROID-X
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongjin,

On 17 December 2012 13:55, Dongjin Kim <tobetter@gmail.com> wrote:
> Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412 SoC.
>
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/Makefile               |    1 +
>  arch/arm/boot/dts/exynos4412-odroidx.dts |   52 ++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index ca6fb8e..3355af9 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -45,6 +45,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>         exynos5250-smdk5250.dtb \
>         exynos5440-ssdk5440.dtb \
>         exynos4412-smdk4412.dtb \
> +       exynos4412-odroidx.dtb \
>         exynos5250-smdk5250.dtb \
>         exynos5250-snow.dtb
>  dtb-$(CONFIG_ARCH_HIGHBANK) += highbank.dtb \
> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
> new file mode 100644
> index 0000000..786ddd7
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -0,0 +1,52 @@
> +/*
> + * Hardkernel's Exynos4412 based ODROID-X board device tree source
> + *
> + * Copyright (c) 2012-2013 Dongjin Kim <tobetter@gmail.com>
> + *
> + * Device tree source file for Hardkernel's ODROID-X board which is based on
> + * Samsung's Exynos4412 SoC.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +/dts-v1/;
> +/include/ "exynos4412.dtsi"
> +
> +/ {
> +       model = "Hardkernel ODROID-X board based on Exynos4412";
> +       compatible = "samsung,exynos4412";
> +
> +       memory {
> +               reg = <0x40000000 0x40000000>;
> +       };
> +
> +       chosen {
> +               bootargs ="root=/dev/mmcblk0p3 rw console=ttySAC1,115200 init=/sbin/init delay=2";
> +       };
> +
> +       serial@13800000 {
> +               status = "okay";
> +       };
> +
> +       serial@13810000 {
> +               status = "okay";
> +       };
> +
> +       serial@13820000 {
> +               status = "okay";
> +       };
> +
> +       serial@13830000 {
> +               status = "okay";
> +       };
> +
> +       sdhci@12530000 {
> +               bus-width = <4>;
> +               samsung,cd-pinmux-gpio = <&gpk2 2 2 3 3>;

The card detect line should also be configured using pinctrl
interface. When pinctrl is enabled on Exynos, the old-style gpio
bindings is not supported. So a pinctrl node for sd2_cmd should be
defined which then can be listed in pinctrl-0.

> +               pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
> +               pinctrl-names = "default";
> +               status = "okay";
> +       };
> +};
> --
> 1.7.9.5
>
