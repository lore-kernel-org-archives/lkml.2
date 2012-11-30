Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2K3Jsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:48:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42112 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2K3Jsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:48:42 -0500
Message-ID: <50B880F5.9060607@gmail.com>
Date: Fri, 30 Nov 2012 10:48:37 +0100
From: Matthias Brugger <matthias.bgg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        grant.likely@secretlab.ca,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM/dts: omap3: Add support for IGEPv2 board
References: <1354144466-750-1-git-send-email-javier.martinez@collabora.co.uk> <1354144466-750-3-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1354144466-750-3-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 12:14 AM, Javier Martinez Canillas wrote:
> ISEE IGEPv2 is an TI OMAP3 SoC based embedded board.
>
> This patch adds an initial device tree support to boot
> an IGEPv2 from the MMC/SD.
>
> Currently is working everything that is supported by DT
> on OMAP3 SoCs (MMC/SD, GPIO LEDs, EEPROM, TWL4030 audio).
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
Acked-by: Matthias Brugger <matthias.bgg@gmail.com>

>   arch/arm/boot/dts/Makefile           |    1 +
>   arch/arm/boot/dts/omap3-igep0020.dts |   56 ++++++++++++++++++++++++++++++++++
>   2 files changed, 57 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm/boot/dts/omap3-igep0020.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index f37cf9f..1dc0f39 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -66,6 +66,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>   	omap3-beagle-xm.dtb \
>   	omap3-evm.dtb \
>   	omap3-tobi.dtb \
> +	omap3-igep0020.dtb \
>   	omap4-panda.dtb \
>   	omap4-pandaES.dtb \
>   	omap4-var_som.dtb \
> diff --git a/arch/arm/boot/dts/omap3-igep0020.dts b/arch/arm/boot/dts/omap3-igep0020.dts
> new file mode 100644
> index 0000000..9dd4d22
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-igep0020.dts
> @@ -0,0 +1,56 @@
> +/*
> + * Device Tree Source for IGEPv2 board
> + *
> + * Copyright (C) 2012 Javier Martinez Canillas <javier@collabora.co.uk>
> + * Copyright (C) 2012 Enric Balletbo i Serra <eballetbo@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/include/ "omap3-igep.dtsi"
> +
> +/ {
> +	model = "IGEPv2";
> +	compatible = "isee,omap3-igep0020", "ti,omap3";
> +
> +	leds {
> +		compatible = "gpio-leds";
> +		boot {
> +			 label = "omap3:green:boot";
> +			 gpios = <&gpio1 26 0>;
> +			 linux,default-trigger = "default-on";
> +		};
> +
> +		user0 {
> +			 label = "omap3:red:user0";
> +			 gpios = <&gpio1 27 0>;
> +			 default-state = "off";
> +		};
> +
> +		user1 {
> +			 label = "omap3:red:user1";
> +			 gpios = <&gpio1 28 0>;
> +			 default-state = "off";
> +		};
> +
> +		user2 {
> +			label = "omap3:green:user1";
> +			gpios = <&twl_gpio 19 1>;
> +		};
> +	};
> +};
> +
> +&i2c3 {
> +	clock-frequency = <100000>;
> +
> +	/*
> +	 * Display monitor features are burnt in the EEPROM
> +	 * as EDID data.
> +	 */
> +	eeprom@50 {
> +		compatible = "ti,eeprom";
> +		reg = <0x50>;
> +	};
> +};
>

