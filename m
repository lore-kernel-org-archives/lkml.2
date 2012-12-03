Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2LCKip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:38:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61003 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2LCKin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <1354270137-31538-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1354270137-31538-1-git-send-email-javier.martinez@collabora.co.uk>
	<1354270137-31538-2-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 3 Dec 2012 11:38:42 +0100
Message-ID: <CAFqH_537iZqH7WuGbMzOMLZqzYBwRw-AAPGgxW=oZ65Lkf4bow@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ARM/dts: omap3: Add generic DT support for IGEP devices
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        grant.likely@secretlab.ca, Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/30 Javier Martinez Canillas <javier.martinez@collabora.co.uk>:
> Add a generic .dtsi device tree source file for the
> common characteristics across IGEP Technology devices.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  arch/arm/boot/dts/omap3-igep.dtsi |   93 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 93 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/omap3-igep.dtsi
>
> diff --git a/arch/arm/boot/dts/omap3-igep.dtsi b/arch/arm/boot/dts/omap3-igep.dtsi
> new file mode 100644
> index 0000000..a093bff
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-igep.dtsi
> @@ -0,0 +1,93 @@
> +/*
> + * Device Tree Source for IGEP Technology devices
> + *
> + * Copyright (C) 2012 Javier Martinez Canillas <javier@collabora.co.uk>
> + * Copyright (C) 2012 Enric Balletbo i Serra <eballetbo@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +
> +/include/ "omap3.dtsi"
> +
> +/ {
> +       memory {
> +               device_type = "memory";
> +               reg = <0x80000000 0x20000000>; /* 512 MB */
> +       };
> +
> +       sound {
> +               compatible = "ti,omap-twl4030";
> +               ti,model = "igep2";
> +               ti,mcbsp = <&mcbsp2>;
> +               ti,codec = <&twl_audio>;
> +       };
> +};
> +
> +&omap3_pmx_core {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <
> +                 &mcbsp2_pins
> +       >;
> +
> +       uart3_pins: pinmux_uart3_pins {
> +               pinctrl-single,pins = <
> +                       0x16e 0x100     /* uart3_rx.uart3_rx INPUT | MODE0 */
> +                       0x170 0         /* uart3_tx.uart3_tx OUTPUT | MODE0 */
> +               >;
> +       };
> +
> +       mcbsp2_pins: pinmux_mcbsp2_pins {
> +               pinctrl-single,pins = <
> +                       0x1a2 0x0104    /* mcspi1_cs2.gpio_176 INPUT | MODE4 */
> +               >;
> +       };
> +};
> +
> +&i2c1 {
> +       clock-frequency = <2600000>;
> +
> +       twl: twl@48 {
> +               reg = <0x48>;
> +               interrupts = <7>; /* SYS_NIRQ cascaded to intc */
> +               interrupt-parent = <&intc>;
> +
> +               vsim: regulator@10 {
> +                       compatible = "ti,twl4030-vsim";
> +                       regulator-min-microvolt = <1800000>;
> +                       regulator-max-microvolt = <3000000>;
> +               };
> +
> +               twl_audio: audio {
> +                       compatible = "ti,twl4030-audio";
> +                       codec {
> +                             };
> +               };
> +       };
> +};
> +
> +/include/ "twl4030.dtsi"
> +
> +&i2c2 {
> +       clock-frequency = <400000>;
> +};
> +
> +&mmc1 {
> +       vmmc-supply = <&vmmc1>;
> +       vmmc_aux-supply = <&vsim>;
> +       bus-width = <8>;
> +};
> +
> +&mmc2 {
> +       status = "disabled";
> +};
> +
> +&mmc3 {
> +       status = "disabled";
> +};
> +
> +&twl_gpio {
> +       ti,use-leds;
> +};
> --
> 1.7.7.6
>

Tested-by: Enric Balletbo i Serra <eballetbo@gmail.com>
