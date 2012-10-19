Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2JSIY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:24:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33174 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2JSIY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:24:26 -0400
Message-ID: <50810E2F.5@ti.com>
Date: Fri, 19 Oct 2012 10:24:15 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
References: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avinash,

This look good to me except the: status = "disabled".

The "disabled" should be reserved for variant that does not contain the IP.
Is it the case here?

Regards,
Benoit

On 09/18/2012 07:30 AM, Philip, Avinash wrote:
> Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> as the driver) is reused from OMAP4.
> 
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Tested-by: Matt Porter <mporter@ti.com>
> ---
> Changes since v1:
>         - Corrected reg offset in reg DT entry.
> 
> :100644 100644 ff3badb... 065fd54... M	arch/arm/boot/dts/am33xx.dtsi
>  arch/arm/boot/dts/am33xx.dtsi |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index ff3badb..065fd54 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -219,5 +219,30 @@
>  			interrupt-parent = <&intc>;
>  			interrupts = <91>;
>  		};
> +
> +		spi0: spi@48030000 {
> +			compatible = "ti,omap4-mcspi";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x48030000 0x400>;
> +			interrupt-parent = <&intc>;
> +			interrupt = <65>;
> +			ti,spi-num-cs = <2>;
> +			ti,hwmods = "spi0";
> +			status = "disabled";
> +
> +		};
> +
> +		spi1: spi@481a0000 {
> +			compatible = "ti,omap4-mcspi";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x481a0000 0x400>;
> +			interrupt-parent = <&intc>;
> +			interrupt = <125>;
> +			ti,spi-num-cs = <2>;
> +			ti,hwmods = "spi1";
> +			status = "disabled";
> +		};
>  	};
>  };
> 

