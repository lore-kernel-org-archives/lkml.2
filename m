Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161274Ab2KNU1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:27:04 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46891 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423335Ab2KNU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:27:01 -0500
MIME-Version: 1.0
In-Reply-To: <1351633367-19082-1-git-send-email-marek.belisko@open-nandra.com>
References: <1351633367-19082-1-git-send-email-marek.belisko@open-nandra.com>
Date: Wed, 14 Nov 2012 21:26:58 +0100
Message-ID: <CAAfyv34D4bTO=k8niM42CDQFb0tP4uOnvX_KPT3+F6z59jPg3Q@mail.gmail.com>
Subject: Re: [PATCH] arm/dts: Add basic support for gta04 (Openmoko next
 generation) board.
From: Belisko Marek <marek.belisko@gmail.com>
To: grant.likely@secretlab.ca, Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC' Grant & Rob

On Tue, Oct 30, 2012 at 10:42 PM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts |   65 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 arch/arm/boot/dts/omap3-gta04.dts
>
> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
> new file mode 100644
> index 0000000..76efd13
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-gta04.dts
> @@ -0,0 +1,65 @@
> +/*
> + * Copyright (C) 2012 Marek Belisko <marek.belisko@open-nandra.com>
> + *
> + * Based on omap3-beagle-xm.dts
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
> +       model = "OMAP3 GTA04";
> +       compatible = "ti,omap3-gta04", "ti,omap3";
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x80000000 0x20000000>; /* 512 MB */
> +       };
> +
> +       gpio-keys {
> +               compatible = "gpio-keys";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               aux-button {
> +                       label = "AUX";
> +                       linux,code = <169>;
> +                       gpios = <&gpio1 7 1>;
> +                       gpio-key,wakeup;
> +               };
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
> +       };
> +};
> +
> +/include/ "twl4030.dtsi"
> +
> +&i2c2 {
> +       clock-frequency = <400000>;
> +       /* Pressure Sensor */
> +       bmp085@77 {
> +               compatible = "bosch,bmp085";
> +               reg = <0x77>;
> +       };
> +};
> +
> +&i2c3 {
> +       clock-frequency = <100000>;
> +};
> +
> +&mmc1 {
> +       vmmc-supply = <&vmmc1>;
> +       bus-width = <4>;
> +};
> +
> --
> 1.7.9.5
>



-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
