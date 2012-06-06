Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2FFJJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:09:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58098 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2FFJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:09:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18CUWk34KSYUCfN+JGTDvyQ
Date: Wed, 6 Jun 2012 02:09:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Uri Yosef <uri.y@variscite.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        oren@variscite.com
Subject: Re: [PATCH] arm/dts: OMAP4: Add Variscite OMAP4 System-On-Modeule
 support
Message-ID: <20120606090931.GV12766@atomide.com>
References: <20120509213156.GZ5140@atomide.com>
 <1337257051-5004-1-git-send-email-uri.y@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337257051-5004-1-git-send-email-uri.y@variscite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Uri Yosef <uri.y@variscite.com> [120517 05:34]:
> Hi Tony,
> 
> This is the updated DTS patch for Vatiscite OMAP4 SOM support

Looks OK to me, but can you please repost one more time with
devicetree-discuss@lists.ozlabs.org in Cc so people have a chance
to ack this patch there?

Thanks,

Tony
 
>  arch/arm/boot/dts/omap4-var_som.dts |   96 +++++++++++++++++++++++++++++++++++
>  1 files changed, 96 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/omap4-var_som.dts
> 
> diff --git a/arch/arm/boot/dts/omap4-var_som.dts b/arch/arm/boot/dts/omap4-var_som.dts
> new file mode 100644
> index 0000000..d41161d
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap4-var_som.dts
> @@ -0,0 +1,96 @@
> +/*
> + * Copyright (C) 2012 Variscite Ltd. - http://www.variscite.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +
> +/include/ "omap4.dtsi"
> +
> +/ {
> +	model = "Variscite OMAP4 SOM";
> +	compatible = "var,omap4-var_som", "ti,omap4430", "ti,omap4";
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x80000000 0x40000000>; /* 1 GB */
> +	};
> +
> +	vdd_eth: fixedregulator@0 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "VDD_ETH";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		enable-active-high;
> +		regulator-boot-on;
> +	};
> +};
> +
> +&i2c1 {
> +	clock-frequency = <400000>;
> +
> +	twl: twl@48 {
> +		reg = <0x48>;
> +		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
> +		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
> +		interrupt-parent = <&gic>;
> +	};
> +};
> +
> +/include/ "twl6030.dtsi"
> +
> +&i2c2 {
> +	clock-frequency = <400000>;
> +};
> +
> +&i2c3 {
> +	clock-frequency = <400000>;
> +
> +	/*
> +	 * Temperature Sensor
> +	 * http://www.ti.com/lit/ds/symlink/tmp105.pdf
> +	 */
> +	tmp105@49 {
> +		compatible = "ti,tmp105";
> +		reg = <0x49>;
> +	};
> +};
> +
> +&i2c4 {
> +	clock-frequency = <400000>;
> +};
> +
> +&mcspi1 {
> +	eth@0 {
> +		compatible = "ks8851";
> +		spi-max-frequency = <24000000>;
> +		reg = <0>;
> +		interrupt-parent = <&gpio6>;
> +		interrupts = <11>; /* gpio line 171 */
> +		vdd-supply = <&vdd_eth>;
> +	};
> +};
> +
> +&mmc1 {
> +	vmmc-supply = <&vmmc>;
> +	ti,bus-width = <8>;
> +	ti,non-removable;
> +};
> +
> +&mmc2 {
> +	status = "disable";
> +};
> +
> +&mmc3 {
> +	status = "disable";
> +};
> +
> +&mmc4 {
> +	status = "disable";
> +};
> +
> +&mmc5 {
> +	ti,bus-width = <4>;
> +};
> -- 
> 1.7.5.4
> 
