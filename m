Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2KENCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:02:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63928 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2KENCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:02:33 -0500
MIME-Version: 1.0
In-Reply-To: <0ea1ba71afb3f4551ac27a6dfa41bd97b63cef48.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<0ea1ba71afb3f4551ac27a6dfa41bd97b63cef48.1351721190.git.josh.cartwright@ni.com>
Date: Mon, 5 Nov 2012 14:02:32 +0100
Message-ID: <CAHTX3d+3CMo1bfJgWexkkgmOFyj9dp-2H4nzKygXOc94LoW0+w@mail.gmail.com>
Subject: Re: [PATCH 8/8] clocksource: xilinx_ttc: add OF_CLK support
From: Michal Simek <monstr@monstr.eu>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 Josh Cartwright <josh.cartwright@ni.com>:
> Add support for retrieving TTC configuration from device tree.  This
> includes the ability to pull information about the driving clocks from
> the of_clk bindings.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi |  53 ++++++++
>  arch/arm/boot/dts/zynq-zc702.dts |  10 ++
>  drivers/clocksource/xilinx_ttc.c | 273 ++++++++++++++++++++++-----------------
>  3 files changed, 218 insertions(+), 118 deletions(-)
>
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 5fb763f..9a2442c 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -109,5 +109,58 @@
>                                 };
>                         };
>                 };
> +
> +               ttc0: ttc0@f8001000 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       compatible = "xlnx,ttc";
> +                       reg = <0xF8001000 0x1000>;
> +                       clocks = <&cpu_clk 3>;
> +                       clock-names = "cpu_1x";
> +                       clock-ranges;
> +
> +                       ttc0_0: ttc0.0 {
> +                               status = "disabled";
> +                               reg = <0>;
> +                               interrupts = <0 10 4>;
> +                       };
> +                       ttc0_1: ttc0.1 {
> +                               status = "disabled";
> +                               reg = <1>;
> +                               interrupts = <0 11 4>;
> +                       };
> +                       ttc0_2: ttc0.2 {
> +                               status = "disabled";
> +                               reg = <2>;
> +                               interrupts = <0 12 4>;
> +                       };
> +               };
> +
> +               ttc1: ttc0@f8002000 {

Also this is ttc1: ttc1.
These type of faults can be simple removed by proper dts node generation.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
