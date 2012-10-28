Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2J1LRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:17:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38433 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2J1LRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:17:30 -0400
Message-ID: <508D1414.2000506@ti.com>
Date: Sun, 28 Oct 2012 16:46:36 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH v3 08/16] ARM: dts: add AM33XX EDMA support
References: <1350566815-409-1-git-send-email-mporter@ti.com> <1350566815-409-9-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-9-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 6:56 PM, Matt Porter wrote:
> Adds AM33XX EDMA support to the am33xx.dtsi as documented in
> Documentation/devicetree/bindings/dma/ti-edma.txt
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/boot/dts/am33xx.dtsi |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index bb31bff..ab9c78f 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -62,6 +62,37 @@
>  			reg = <0x48200000 0x1000>;
>  		};
>  
> +		edma: edma@49000000 {
> +			compatible = "ti,edma3";
> +			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> +			reg =	<0x49000000 0x10000>,
> +				<0x44e10f90 0x10>;
> +			interrupt-parent = <&intc>;
> +			interrupts = <12 13 14>;
> +			#dma-cells = <1>;
> +			dma-channels = <64>;
> +			ti,edma-regions = <4>;
> +			ti,edma-slots = <256>;
> +			ti,edma-reserved-channels = <0  2
> +						     14 2
> +						     26 6
> +						     48 4
> +						     56 8>;
> +			ti,edma-reserved-slots = <0  2
> +						  14 2
> +						  26 6
> +						  48 4
> +						  56 8
> +						  64 127>;

No need to reserve any channels or slots on AM335x, I think. This is
used on DaVinci devices to share channels with DSP. I am not sure the
cortex-M3 or PRU on the AM335x need to (or even can) have EDMA access.

Thanks,
Sekhar
