Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2J3FfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:35:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52261 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab2J3FfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:35:11 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 13/16] ARM: dts: add AM33XX MMC support
Thread-Topic: [RFC PATCH v3 13/16] ARM: dts: add AM33XX MMC support
Thread-Index: AQHNrTR1ukj4M+0aw0mqfpQ/EnwANpfRXzmA
Date: Tue, 30 Oct 2012 05:33:40 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA5AE57@DBDE01.ent.ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-14-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-14-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 18:56:52, Porter, Matt wrote:
> Adds AM33XX MMC support for am335x-bone and am335x-evm.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/boot/dts/am335x-bone.dts |    6 ++++++
>  arch/arm/boot/dts/am335x-evm.dts  |    6 ++++++
>  arch/arm/boot/dts/am33xx.dtsi     |   27 +++++++++++++++++++++++++++
>  3 files changed, 39 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index c634f87..5510979 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -70,6 +70,8 @@
>  		};
>  
>  		ldo3_reg: regulator@5 {
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <3300000>;

I think these min & max limits are regulator limits. Are these fields
required? Add details of these additions. AFAIK fine-tuned (board
specific) min/max limits should be add here(like mpu and core
regulator nodes)

>  			regulator-always-on;
>  		};
>  
> @@ -78,3 +80,7 @@
>  		};
>  	};
>  };
> +
> +&mmc1 {
> +	vmmc-supply = <&ldo3_reg>;
> +};
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 185d632..d63fce8 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -114,7 +114,13 @@
>  		};
>  
>  		vmmc_reg: regulator@12 {
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <3300000>;

=same=

>  			regulator-always-on;
>  		};
>  	};
>  };
> +
> +&mmc1 {
> +	vmmc-supply = <&vmmc_reg>;
> +};
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index ab9c78f..26a6af7 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -234,6 +234,33 @@
>  			status = "disabled";
>  		};
>  
> +		mmc1: mmc@48060000 {
> +			compatible = "ti,omap3-hsmmc";
> +			ti,hwmods = "mmc1";
> +			ti,dual-volt;
> +			ti,needs-special-reset;
> +			dmas = <&edma 24
> +				&edma 25>;
> +			dma-names = "tx", "rx";

Add status = "disabled" here and "okay" in corresponding
.dts file

> +		};
> +
> +		mmc2: mmc@481d8000 {
> +			compatible = "ti,omap3-hsmmc";
> +			ti,hwmods = "mmc2";
> +			ti,needs-special-reset;
> +			dmas = <&edma 2
> +				&edma 3>;
> +			dma-names = "tx", "rx";
> +			status = "disabled";
> +		};
> +
> +		mmc3: mmc@47810000 {
> +			compatible = "ti,omap3-hsmmc";
> +			ti,hwmods = "mmc3";
> +			ti,needs-special-reset;

What about DMA resources for mmc3?

AnilKumar

> +			status = "disabled";
> +		};
> +
>  		wdt2: wdt@44e35000 {
>  			compatible = "ti,omap3-wdt";
>  			ti,hwmods = "wd_timer2";
> -- 
> 1.7.9.5
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

