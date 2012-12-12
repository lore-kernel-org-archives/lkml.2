Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2LLQJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:09:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55197 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab2LLQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:09:50 -0500
Message-ID: <50C8AC3C.9020908@ti.com>
Date: Wed, 12 Dec 2012 17:09:32 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <tony@atomide.com>, <grant.likely@secretlab.ca>, <eballetbo@gmail.com>,
        <elezegarcia@gmail.com>, <ebutera@gmail.com>,
        <javier.martinez@collabora.co.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: dts: Add uart1 and uart2 to igep boards.
References: <1355326422-12357-1-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1355326422-12357-1-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On 12/12/2012 04:33 PM, Matthias Brugger wrote:
> This patch is a follow-up patch for Javier Martinez effort adding initial
> device tree support to IGEP technology devices. [1]
> 
> It adds uart1 and uart2 bindings to the generic dtsi for the IGEP boards.
> 
> [1] http://www.spinics.net/lists/linux-omap/msg83409.html
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  arch/arm/boot/dts/omap3-igep.dtsi |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-igep.dtsi b/arch/arm/boot/dts/omap3-igep.dtsi
> index 125fe00..c02e3c0 100644
> --- a/arch/arm/boot/dts/omap3-igep.dtsi
> +++ b/arch/arm/boot/dts/omap3-igep.dtsi
> @@ -27,6 +27,20 @@
>  };
>  
>  &omap3_pmx_core {
> +	uart1_pins: pinmux_uart1_pins {
> +		pinctrl-single,pins = <
> +			0x152 0x100	/* uart1_rx.uart1_rx INPUT | MODE0 */
> +			0x14c 0		/* uart1_tx.uart1_tx OUTPUT | MODE0 */
> +		>;
> +	};
> +
> +	uart2_pins: pinmux_uart2_pins {
> +		pinctrl-single,pins = <
> +			0x14a 0x100	/* uart2_rx.uart2_rx INPUT | MODE0 */
> +			0x148 0		/* uart2_tx.uart2_tx OUTPUT | MODE0 */
> +		>;
> +	};
> +
>  	uart3_pins: pinmux_uart3_pins {
>  		pinctrl-single,pins = <
>  			0x16e 0x100	/* uart3_rx.uart3_rx INPUT | MODE0 */
> @@ -77,6 +91,16 @@
>  	status = "disabled";
>  };
>  
> +&uart1 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&uart1_pins>;
> +};
> +
> +&uart2 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&uart2_pins>;
> +};
> +
>  &uart3 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&uart3_pins>;
> 

That looks good to me. I'll apply it on top of javier's series for 3.9.

Thanks,
Benoit

