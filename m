Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2IRN2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:28:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57866 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2IRN2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:28:20 -0400
Message-ID: <505876F0.6010809@gmail.com>
Date: Tue, 18 Sep 2012 08:28:16 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Describe interrupt-controller binding
References: <1347958274-19425-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1347958274-19425-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 03:51 AM, Thierry Reding wrote:
> In order to use GPIO controllers as interrupt controllers, they need to
> be marked with the DT interrupt-controller property. This commit adds
> some documentation about this to the general GPIO binding document.
> 
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Applied for 3.7.

Rob

> ---
>  Documentation/devicetree/bindings/gpio/gpio.txt | 33 +++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
> index 4e16ba4..8d125b0 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
> @@ -75,4 +75,37 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
>  		gpio-controller;
>  	};
>  
> +If the GPIO controller supports the generation of interrupts, it should
> +also contain an empty "interrupt-controller" property as well as an
> +"#interrupt-cells" property. This is required in order for other nodes
> +to use the GPIO controller as their interrupt parent.
>  
> +If #interrupt-cells is 1, the single cell is used to specify the number
> +of the GPIO that is to be used as an interrupt.
> +
> +If #interrupt-cells is 2, the first cell is used to specify the number
> +of the GPIO that is to be used as an interrupt, whereas the second cell
> +is used to specify any of the following flags:
> +  - bits[3:0] trigger type and level flags
> +      1 = low-to-high edge triggered
> +      2 = high-to-low edge triggered
> +      4 = active high level-sensitive
> +      8 = active low level-sensitive
> +
> +Example:
> +
> +	gpioext: gpio-controller@41 {
> +		compatible = "ad,gpio-adnp";
> +		reg = <0x41>;
> +
> +		interrupt-parent = <&gpio>;
> +		interrupts = <160 1>;
> +
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +
> +		nr-gpios = <64>;
> +	};
> 
