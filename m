Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab1HGFcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 01:32:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38579 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1HGFcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 01:32:51 -0400
Date: Sat, 6 Aug 2011 21:44:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] AT91: dt: at91sam9g45 family and board device
 tree files
Message-ID: <20110807034433.GB7667@ponder.secretlab.ca>
References: <1312561493-7849-1-git-send-email-nicolas.ferre@atmel.com>
 <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 05:24:52PM +0100, Nicolas Ferre wrote:
> Create a new device tree source file for Atmel at91sam9g45 SoC family.
> The Evaluation Kit at91sam9m10g45ek includes it.
> This first basic support will be populated as drivers and boards will be
> converted to device tree.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi     |   27 +++++++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9m10g45ek.dts |   15 +++++++++++++++
>  2 files changed, 42 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9g45.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9m10g45ek.dts
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> new file mode 100644
> index 0000000..3d85f96
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -0,0 +1,27 @@
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Atmel AT91SAM9G45 family SoC";
> +	compatible = "atmel,at91sam9g45", "atmel,at91sam9m10", "atmel,at91sam9g46", "atmel,at91sam9m11";

You'll need documentation for these new compatible values in
Documentation/devicetree/bindings.

> +	interrupt-parent = <&aic>;
> +
> +	memory {
> +		reg = <0x70000000 0x10000000>;
> +	};
> +
> +	aic: interrupt-controller@fffff000 {
> +		#interrupt-cells = <1>;
> +		compatible = "atmel,aic";

'atmel,aic' is pretty generic and it assumes that the interrupt
controller doesn't change between SoC versions.  Either specify the
SoC name in the compatible property, or if it is well documented, the
name + version of the IP block.

> +		interrupt-controller;
> +		reg = <0xfffff000 0x200>;
> +	};
> +
> +	dma@ffffec00 {
> +		compatible = "atmel,at91sam9g45-hdmac";
> +		reg = <0xffffec00 0x200>;
> +		interrupts = <21>;
> +		atmel,hdmac-nr-channels = <8>;
> +		atmel,hdmac-cap-memcpy;
> +		atmel,hdmac-cap-slave;

You can probably drop the "hdmac-" bit here, but that's just
nitpicking.  Regardless, make sure you document the properties.

> +	};
> +};
> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> new file mode 100644
> index 0000000..48252c9
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> @@ -0,0 +1,15 @@
> +/dts-v1/;
> +/include/ "at91sam9g45.dtsi"
> +
> +/ {
> +	model = "Atmel AT91SAM9M10G45-EK";
> +	compatible = "atmel,at91sam9m10g45ek", "atmel,at91sam9g45ekes", "atmel,at91sam9m10ekes", "atmel,at91sam9g45", "atmel,at91sam9m10", "atmel,at91sam9g46", "atmel,at91sam9m11", "atmel,at91";

This list has gotten rather long.  What do all these values mean?
Also, "atmel,at91" looks rather too generic and is probably not the
right thing to do.

> +
> +	chosen {
> +		bootargs = "mem=64M console=ttyS0,115200 mtdparts=atmel_nand:4M(bootstrap/uboot/kernel)ro,60M(rootfs),-(data) root=/dev/mtdblock1 rw rootfstype=jffs2";
> +	};
> +
> +	memory {
> +		reg = <0x70000000 0x4000000>;
> +	};
> +};
> -- 
> 1.7.4.1
> 
