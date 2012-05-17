Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030623Ab2ERBvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:51:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33707 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030596Ab2ERBvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:51:35 -0400
Message-ID: <4FB58A7A.4060606@gmail.com>
Date: Thu, 17 May 2012 18:32:10 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH RESEND v3 2/2] ARM: LPC32xx: Make platform use key driver
References: <1337199955-26441-1-git-send-email-stigge@antcom.de> <1337199955-26441-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1337199955-26441-2-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 03:25 PM, Roland Stigge wrote:
> This patch connects the lpc32xx-key driver to the LPC32xx platform (via
> lpc32xx.dtsi), and more specifically to the reference board via its dts file.
> The clock.c file needs to be changed to match the automatic device name to its
> clock.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> 
> ---
> Applies to v3.4-rc7 + LPC32xx DT patches
> 
> Please pick this patch for the arm-soc subsystem.
> 
> Changes since v2:
> * DT: Use "keypad,num-rows", "keypad,num-columns" and "linux,keymap" properties
> 
>  arch/arm/boot/dts/lpc32xx.dtsi |    2 ++
>  arch/arm/boot/dts/phy3250.dts  |    9 +++++++++
>  arch/arm/mach-lpc32xx/clock.c  |    2 +-
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
> +++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
> @@ -249,6 +249,8 @@
>  			key@40050000 {
>  				compatible = "nxp,lpc3220-key";
>  				reg = <0x40050000 0x1000>;
> +				interrupts = <54 0>;
> +				status = "disable";
>  			};
>  
>  		};
> --- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
> +++ linux-2.6/arch/arm/boot/dts/phy3250.dts
> @@ -135,6 +135,15 @@
>  			tsc@40048000 {
>  				status = "okay";
>  			};
> +
> +			key@40050000 {
> +				status = "okay";
> +				keypad,num-rows = <1>;
> +				keypad,num-columns = <1>;
> +				nxp,debounce-delay-ms = <3>;
> +				nxp,scan-delay-ms = <34>;
> +				linux,keymap = <0x00000002>;
> +			};
>  		};
>  	};
>  
> --- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
> +++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
> @@ -1134,7 +1134,7 @@ static struct clk_lookup lookups[] = {
>  	CLKDEV_INIT("31020300.i2c", NULL, &clk_i2c2),
>  	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
>  	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
> -	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
> +	CLKDEV_INIT("40050000.key", NULL, &clk_kscan),
>  	CLKDEV_INIT("20020000.flash", NULL, &clk_nand),
>  	CLKDEV_INIT("200a8000.flash", NULL, &clk_nand_mlc),
>  	CLKDEV_INIT("40048000.adc", NULL, &clk_adc),
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

