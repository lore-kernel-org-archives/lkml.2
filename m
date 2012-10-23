Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2JWOt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:49:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35559 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab2JWOt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:49:57 -0400
Message-ID: <5086AE8E.60106@ti.com>
Date: Tue, 23 Oct 2012 09:49:50 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastien Guiriec <s-guiriec@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap5: Update GPIO with address space
 and interrupts
References: <1350981432-6750-1-git-send-email-s-guiriec@ti.com> <1350981432-6750-2-git-send-email-s-guiriec@ti.com>
In-Reply-To: <1350981432-6750-2-git-send-email-s-guiriec@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seb,

On 10/23/2012 03:37 AM, Sebastien Guiriec wrote:
> Add base address and interrupt line inside Device Tree data for
> OMAP5
> 
> Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
> ---
>  arch/arm/boot/dts/omap5.dtsi |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 42c78be..9e39f9f 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -104,6 +104,8 @@
>  
>  		gpio1: gpio@4ae10000 {
>  			compatible = "ti,omap4-gpio";
> +			reg = <0x4ae10000 0x200>;
> +			interrupts = <0 29 0x4>;
>  			ti,hwmods = "gpio1";
>  			gpio-controller;
>  			#gpio-cells = <2>;

I am wondering if we should add the "interrupt-parent" property to add
nodes in the device-tree source. I know that today the interrupt-parent
is being defined globally, but when device-tree maps an interrupt for a
device it searches for the interrupt-parent starting the current device
node.

So in other words, for gpio1 it will search the gpio1 binding for
"interrupt-parent" and if not found move up a level and search again. It
will keep doing this until it finds the "interrupt-parent".

Therefore, I believe it will improve search time and hence, boot time if
we have interrupt-parent defined in each node.

Cheers
Jon
