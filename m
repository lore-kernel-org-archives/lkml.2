Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2CNHk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:40:59 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:58084 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752653Ab2CNHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:40:55 -0400
Date: Wed, 14 Mar 2012 08:28:39 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vinod.koul@linux.intel.com, s.hauer@pengutronix.de,
        rob.herring@calxeda.com, rdunlap@xenotime.net, kernel@pengutronix.de,
        cjb@laptop.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v1 3/5] ARM: imx28evk: add mmc dt support
Message-ID: <20120314072839.GH18320@game.jcrosoft.org>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-4-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331628428-24017-4-git-send-email-b29396@freescale.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5435563275613612903
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:47 Tue 13 Mar     , Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  arch/arm/boot/dts/imx28-evk.dts |   14 ++++++++++++++
>  arch/arm/boot/dts/imx28.dtsi    |   33 +++++++++++++++++++++++++++++++++
>  arch/arm/mach-mxs/imx28-dt.c    |    2 ++
>  3 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-evk.dts
> index 9758dc4..61350ab 100644
> --- a/arch/arm/boot/dts/imx28-evk.dts
> +++ b/arch/arm/boot/dts/imx28-evk.dts
> @@ -21,6 +21,20 @@
>  		reg = <0x40000000 0x08000000>;
>  	};
>  
> +        apb@80000000 {
> +                apbh@80000000 {
> +			mmc1: ssp@80010000 {
> +				slot-8bit;
> +				status = "okay";
> +			};
> +
> +			mmc2: ssp@80012000 {
> +				slot-8bit;
> +				status = "okay";
> +			};
> +		};
> +	};
> +
>  	ahb@80080000 {
>  		fec@800f0000 {
>  			phy-mode = "rmii";
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> index acf0dab..71c7bfb 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -46,6 +46,39 @@
>  				#interrupt-cells = <1>;
>  				reg = <0x80000000 0x2000>;
>  			};
> +
> +			ssp@80010000 {
> +				compatible = "fsl,imx28-mmc";
> +				reg = <0x80010000 2000>;
> +				/* <irq_err irq_dma> */
> +				interrupts = <96 82>;
> +				dma_channel = <0>;
> +				status = "disabled";
> +			};
> +
> +			ssp@80012000 {
> +				compatible = "fsl,imx28-mmc";
> +				reg = <0x80012000 2000>;
> +				interrupts = <97 83>;
> +				dma_channel = <1>;
> +				status = "disabled";
> +			};
> +
> +			ssp@80014000 {
> +				compatible = "fsl,imx28-mmc";
> +				reg = <0x80014000 2000>;
> +				interrupts = <98 84>;
> +				dma_channel = <2>;
> +				status = "disabled";
> +			};
> +
> +			ssp@80016000 {
> +				compatible = "fsl,imx28-mmc";
> +				reg = <0x80016000 2000>;
> +				interrupts = <99 85>;
> +				dma_channel = <3>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		apbx@80040000 {
> diff --git a/arch/arm/mach-mxs/imx28-dt.c b/arch/arm/mach-mxs/imx28-dt.c
> index 78d1129..429b88e 100644
> --- a/arch/arm/mach-mxs/imx28-dt.c
> +++ b/arch/arm/mach-mxs/imx28-dt.c
> @@ -23,6 +23,8 @@ static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
>  	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart", NULL),
>  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR, "imx28-fec.0", NULL),
>  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
> +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP0_BASE_ADDR, "mxs-mmc.0", NULL),
> +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP1_BASE_ADDR, "mxs-mmc.1", NULL),
do we really need to continue to add OF_DEV_AUXDATA

instead add a clkdev entry

IIRC OF_DEV_AUXDATA was a temporary solution, we need to stop to use it more
and more

Best Reards,
J.
