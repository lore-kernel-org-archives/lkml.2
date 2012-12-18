Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2LRCEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:04:40 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45852 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2LRCEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:04:39 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1355774107-364-2-git-send-email-tobetter@gmail.com>
References: <1355774107-364-1-git-send-email-tobetter@gmail.com>
	<1355774107-364-2-git-send-email-tobetter@gmail.com>
Date: Mon, 17 Dec 2012 17:56:39 -0800
Message-ID: <CAOesGMgZWNiCmTFGvr--zKf+vS51hX5jPnD+NZq8OvGFLS9rJA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ODROID-X: dts: Add board dts file for ODROID-X
From: Olof Johansson <olof@lixom.net>
To: Dongjin Kim <tobetter@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:55 AM, Dongjin Kim <tobetter@gmail.com> wrote:
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

Please add them alphabetically, so before smdk.

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

Are you from the future?

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

It should have a more specific compatible value first, i.e.
"hardkernel,odroid-x" or similar.


> +       memory {
> +               reg = <0x40000000 0x40000000>;
> +       };
> +
> +       chosen {
> +               bootargs ="root=/dev/mmcblk0p3 rw console=ttySAC1,115200 init=/sbin/init delay=2";

Bootargs should be passed in from u-boot, don't specify them in the
static device tree.



-Olof
