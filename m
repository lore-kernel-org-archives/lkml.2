Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab2IKJ0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:26:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46394 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab2IKJ0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:26:54 -0400
Message-ID: <504F03D4.5080800@ti.com>
Date: Tue, 11 Sep 2012 11:26:44 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] arm/dts: Add twl6030-usb data
References: <1347345381-4390-1-git-send-email-kishon@ti.com> <1347345381-4390-2-git-send-email-kishon@ti.com>
In-Reply-To: <1347345381-4390-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
> Add twl6030-usb data node in twl6030 device tree file
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/omap4-panda.dts |    4 ++++
>  arch/arm/boot/dts/omap4-sdp.dts   |    4 ++++
>  arch/arm/boot/dts/twl6030.dtsi    |    5 +++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
> index 9880c12..2999eba 100644
> --- a/arch/arm/boot/dts/omap4-panda.dts
> +++ b/arch/arm/boot/dts/omap4-panda.dts
> @@ -126,3 +126,7 @@
>  	ti,non-removable;
>  	bus-width = <4>;
>  };
> +
> +&twlusb {
> +	usb-supply = <&vusb>;
> +};
> diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
> index 72216e9..d8290c0 100644
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -226,3 +226,7 @@
>  	bus-width = <4>;
>  	ti,non-removable;
>  };
> +
> +&twlusb {
> +	usb-supply = <&vusb>;
> +};
> diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
> index 3b2f351..8e3aac9 100644
> --- a/arch/arm/boot/dts/twl6030.dtsi
> +++ b/arch/arm/boot/dts/twl6030.dtsi
> @@ -83,4 +83,9 @@
>  	clk32kg: regulator@12 {
>  		compatible = "ti,twl6030-clk32kg";
>  	};
> +
> +	twlusb: twl6030-usb {

That name should be a generic device class name is possible.
What is twl6030-usb exactly? an USB PHY?

> +		compatible = "ti,twl6030-usb";
> +		interrupts = < 4 10 >;

If this is for two interrupts, you'd better split them to avoid
confusion with irq specifiers that requires several attributes like for
the GIC.

+		interrupts = <4>, <10>; /* IRQ1 blabla, IRQ2 blabla*/

The comments are not mandatory assuming the binding is documented.

Regards,
Benoit


