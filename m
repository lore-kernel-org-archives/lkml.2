Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2IKKJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:09:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52773 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2IKKJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:09:44 -0400
Message-ID: <504F0DDE.308@ti.com>
Date: Tue, 11 Sep 2012 12:09:34 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] arm/dts: Add twl4030-usb data
References: <1347345381-4390-1-git-send-email-kishon@ti.com> <1347345381-4390-3-git-send-email-kishon@ti.com>
In-Reply-To: <1347345381-4390-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
> Add twl4030-usb data node in twl4030 device tree file.

IIRC, the usb part on twl4030 was doing more than it does on twl6030.

Could you describe what part of the USB is really done by the TWL in
that case?

> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/twl4030.dtsi |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
> index 22f4d13..761a5a5 100644
> --- a/arch/arm/boot/dts/twl4030.dtsi
> +++ b/arch/arm/boot/dts/twl4030.dtsi
> @@ -37,6 +37,18 @@
>  		regulator-max-microvolt = <3150000>;
>  	};
>  
> +	vusb1v5: regulator-vusb1v5 {
> +		compatible = "ti,twl4030-vusb1v5";
> +	};
> +
> +	vusb1v8: regulator-vusb1v8 {
> +		compatible = "ti,twl4030-vusb1v8";
> +	};
> +
> +	vusb3v1: regulator-vusb3v1 {
> +		compatible = "ti,twl4030-vusb3v1";
> +	};
> +
>  	twl_gpio: gpio {
>  		compatible = "ti,twl4030-gpio";
>  		gpio-controller;
> @@ -44,4 +56,13 @@
>  		interrupt-controller;
>  		#interrupt-cells = <1>;
>  	};
> +
> +	twl4030-usb {

Same comment than before about the name. Is it the usb-comparator as well?

> +		compatible = "ti,twl4030-usb";
> +		interrupts = < 10 4 >;
> +		usb1v5-supply = <&vusb1v5>;
> +		usb1v8-supply = <&vusb1v8>;
> +		usb3v1-supply = <&vusb3v1>;
> +		usb_mode = <1>;

Is this a TI only attribute or something generic?

If this is TI only, it should be prefix with "ti," otherwise, it is fine.

Regards,
Benoit

