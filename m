Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2CVHpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:45:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33680 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2CVHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:45:33 -0400
Date: Thu, 22 Mar 2012 15:45:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: Re: [PATCH] ARM: dts: imx6q: add anatop regulators
Message-ID: <20120322074520.GD2213@S2101-09.ap.freescale.net>
References: <1332214139-6833-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1332214139-6833-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 11:28:59AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Add anatop regulators to imx6q.dtsi for all imx6q platforms.
> 
I would expect all those regulator device nodes be sorted by
register offset, and for the devices sharing the same register they
can be sorted by anatop-vol-bit-shift.

I'm looking at the IMX6DQRM Rev. C, and commenting the differences
I'm seeing from the document below.

> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> ---
>  arch/arm/boot/dts/imx6q.dtsi |   86 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 86 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index 263e8f3..dd41514 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -346,6 +346,92 @@
>  				compatible = "fsl,imx6q-anatop";
>  				reg = <0x020c8000 0x1000>;
>  				interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				regulator-vddpu@140 {
> +					compatible = "fsl,anatop-regulator";
> +					regulator-name = "vddpu";
> +					regulator-min-microvolt = <725000>;
> +					regulator-max-microvolt = <1300000>;
> +					regulator-always-on;
> +					reg = <0x140>;
> +					anatop-vol-bit-shift = <9>;
> +					anatop-vol-bit-width = <5>;
> +					anatop-min-bit-val = <1>;
> +					anatop-min-voltage = <725000>;
> +					anatop-max-voltage = <1300000>;

1.450V

> +				};
> +
> +				regulator-vddcore@140 {
> +					compatible = "fsl,anatop-regulator";
> +					regulator-name = "cpu";
> +					regulator-min-microvolt = <725000>;
> +					regulator-max-microvolt = <1300000>;
> +					regulator-always-on;
> +					reg = <0x140>;
> +					anatop-vol-bit-shift = <0>;
> +					anatop-vol-bit-width = <5>;
> +					anatop-min-bit-val = <1>;
> +					anatop-min-voltage = <725000>;
> +					anatop-max-voltage = <1300000>;

Ditto

> +				};
> +
> +				regulator-vddsoc@140 {
> +					compatible = "fsl,anatop-regulator";
> +					regulator-name = "vddsoc";
> +					regulator-min-microvolt = <725000>;
> +					regulator-max-microvolt = <1300000>;
> +					regulator-always-on;
> +					reg = <0x140>;
> +					anatop-vol-bit-shift = <18>;
> +					anatop-vol-bit-width = <5>;
> +					anatop-min-bit-val = <1>;
> +					anatop-min-voltage = <725000>;
> +					anatop-max-voltage = <1300000>;

Ditto

> +				};
> +
> +				regulator-2p5@130 {
> +					compatible = "fsl,anatop-regulator";
> +					regulator-name = "vdd2p5";
> +					regulator-min-microvolt = <2000000>;
> +					regulator-max-microvolt = <2775000>;
> +					regulator-always-on;
> +					reg = <0x130>;
> +					anatop-vol-bit-shift = <8>;
> +					anatop-vol-bit-width = <5>;
> +					anatop-min-bit-val = <0>;
> +					anatop-min-voltage = <2000000>;
> +					anatop-max-voltage = <2775000>;

2.75V

> +				};
> +
> +				regulator-1p1@110 {
> +					compatible = "fsl,anatop-regulator";
> +					regulator-name = "vdd1p1";
> +					regulator-min-microvolt = <800000>;
> +					regulator-max-microvolt = <1400000>;
> +					regulator-always-on;
> +					reg = <0x110>;
> +					anatop-vol-bit-shift = <8>;
> +					anatop-vol-bit-width = <5>;
> +					anatop-min-bit-val = <4>;
> +					anatop-min-voltage = <800000>;
> +					anatop-max-voltage = <1400000>;

1.375V

> +				};
> +
> +				regulator-3p0@120 {
> +					compatible = "fsl,anatop-regulator";
> +					regulator-name = "vdd3p0";
> +					regulator-min-microvolt = <2800000>;
> +					regulator-max-microvolt = <3150000>;
> +					regulator-always-on;
> +					reg = <0x120>;
> +					anatop-vol-bit-shift = <8>;
> +					anatop-vol-bit-width = <5>;
> +					anatop-min-bit-val = <7>;

0

> +					anatop-min-voltage = <2800000>;

2.625V

> +					anatop-max-voltage = <3150000>;

3.4V

> +				};
>  			};
>  
>  			usbphy@020c9000 { /* USBPHY1 */
> -- 
> 1.7.9.1
> 

-- 
Regards,
Shawn
