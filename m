Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2IKKSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:18:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53180 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab2IKKSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:18:40 -0400
Message-ID: <504F0FF4.1090000@ti.com>
Date: Tue, 11 Sep 2012 12:18:28 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] arm/dts: omap: Add usb_otg and glue data
References: <1347345381-4390-1-git-send-email-kishon@ti.com> <1347345381-4390-4-git-send-email-kishon@ti.com>
In-Reply-To: <1347345381-4390-4-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
> Add usb otg data node in omap4/omap3 device tree file. Also update
> the node with board specific setting in omapx-<board>.dts file.
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
>  arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
>  arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
>  arch/arm/boot/dts/omap4-panda.dts  |    6 ++++++
>  arch/arm/boot/dts/omap4-sdp.dts    |    6 ++++++
>  arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
>  6 files changed, 40 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
> index cdcb98c..6d6a7a4 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -67,3 +67,9 @@
>  &mmc3 {
>  	status = "disabled";
>  };
> +
> +&usb_otg_hs {
> +	interface_type = <0>;
> +	mode = <3>;
> +	power = <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-evm.dts
> index f349ee9..c4ac75e 100644
> --- a/arch/arm/boot/dts/omap3-evm.dts
> +++ b/arch/arm/boot/dts/omap3-evm.dts
> @@ -46,3 +46,9 @@
>  		reg = <0x5c>;
>  	};
>  };
> +
> +&usb_otg_hs {
> +	interface_type = <0>;
> +	mode = <3>;
> +	power = <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index 8109471..2501416 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -220,5 +220,13 @@
>  			compatible = "ti,omap3-wdt";
>  			ti,hwmods = "wd_timer2";
>  		};
> +
> +		usb_otg_hs: usb_otg_hs {
> +			compatible = "ti,omap3-musb";
> +			ti,hwmods = "usb_otg_hs";
> +			multipoint = <1>;
> +			num_eps = <16>;
> +			ram_bits = <12>;
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
> index 2999eba..8cded95 100644
> --- a/arch/arm/boot/dts/omap4-panda.dts
> +++ b/arch/arm/boot/dts/omap4-panda.dts
> @@ -130,3 +130,9 @@
>  &twlusb {
>  	usb-supply = <&vusb>;
>  };
> +
> +&usb_otg_hs {
> +	interface_type = <1>;
> +	mode = <3>;
> +	power = <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
> index d8290c0..24f4bfd 100644
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -230,3 +230,9 @@
>  &twlusb {
>  	usb-supply = <&vusb>;
>  };
> +
> +&usb_otg_hs {
> +	interface_type = <1>;
> +	mode = <3>;
> +	power = <50>;
> +};
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 04cbbcb..5db3d6a 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -295,5 +295,13 @@
>  			interrupt-parent = <&gic>;
>  			ti,hwmods = "dmic";
>  		};
> +
> +		usb_otg_hs: usb_otg_hs {

After rebasing your series on top of devel-dt, you should as well add
the missing reg/irq entries that are now supported thanks to Vaibhav.

Regards,
Benoit

> +			compatible = "ti,omap4-musb";
> +			ti,hwmods = "usb_otg_hs";
> +			multipoint = <1>;
> +			num_eps = <16>;
> +			ram_bits = <12>;
> +		};
>  	};
>  };
> 

