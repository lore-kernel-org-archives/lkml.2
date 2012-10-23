Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2JWSI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:08:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38006 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756708Ab2JWSI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:08:26 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX199SwskAyd9k+Cq2pCmPR1cRruA02deVofY+38XKo
	++z42YPuB0sEqd
From: Marc Dietrich <marvin24@gmx.de>
To: Pavan Kunapuli <pkunapuli@nvidia.com>
Cc: swarren@wwwdotorg.org, linux@arm.linux.org.uk, cjb@laptop.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dt: tegra: Add sdhci regulators
Date: Tue, 23 Oct 2012 20:07:59 +0200
Message-ID: <4346406.Jy2o1pWcOR@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-17-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350976740-19284-2-git-send-email-pkunapuli@nvidia.com>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com> <1350976740-19284-2-git-send-email-pkunapuli@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavan,

On Tuesday 23 October 2012 12:48:59 Pavan Kunapuli wrote:
> Adding vmmc and vmmcq supplies for sdhci nodes
> in tegra dt files.

<...>

> diff --git a/arch/arm/boot/dts/tegra20-paz00.dts
> b/arch/arm/boot/dts/tegra20-paz00.dts index 6a93d14..e161b65 100644
> --- a/arch/arm/boot/dts/tegra20-paz00.dts
> +++ b/arch/arm/boot/dts/tegra20-paz00.dts
> @@ -422,13 +422,17 @@
>  		status = "okay";
>  		cd-gpios = <&gpio 173 0>; /* gpio PV5 */
>  		wp-gpios = <&gpio 57 0>;  /* gpio PH1 */
> -		power-gpios = <&gpio 169 0>; /* gpio PV1 */
>  		bus-width = <4>;
> +		vmmc-supply = <&vddio_sd_reg>;
> +		vqmmc-supply = <&vddio_sd_reg>;
>  	};
> 
>  	sdhci@c8000600 {
>  		status = "okay";
>  		bus-width = <8>;
> +		vmmc-supply = <&vddio_sdmmc_reg>;
> +		vqmmc-supply = <&vddio_sdmmc_reg>;

to make it better, this should be:

vmmc-supply = <&vcore_mmc_reg>; and
vqmmc-supply = <&vddio_nand_reg>;

with vcore_mmc_reg is ldo5 and vddio_nand_reg is the fixed regulator below.

By doing so, I get "sdhci-tegra sdhci-tegra.3: could not set regulator OCR 
(-1)". MMC subsys wants to set ldo5 to 3.3V but it is fixed. I guess that's 
harmless for now. 

>  	};
> 
>  	gpio-keys {
> @@ -465,6 +469,24 @@
>  			regulator-max-microvolt = <5000000>;
>  			regulator-always-on;
>  		};
> +
> +		vddio_sd_reg: regulator@1 {
> +			compatible = "regulator-fixed";
> +			reg = <1>;
> +			regulator-name = "vddio_sd";
> +			regulator-min-microvolt = <3300000>;
> +			regulator-max-microvolt = <3300000>;
> +			enable-active-high;
> +			gpio = <&gpio 169 0>; /* gpio PV1 */
> +		};
> +
> +		vddio_sdmmc_reg: regulator@2 {

       ^^ vddio_nand_reg acording to schematics

> +			compatible = "regulator-fixed";
> +			reg = <2>;
> +			regulator-name  = "vddio_sdmmc";

also here

> +			regulator-min-microvolt = <3300000>;
> +			regulator-max-microvolt = <3300000>;
> +		};
>  	};
> 
>  	sound {

