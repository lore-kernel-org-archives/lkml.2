Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab2KBJUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:20:38 -0400
Received: from smtp-out-184.synserver.de ([212.40.185.184]:1060 "EHLO
	smtp-out-184.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab2KBJUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:20:36 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15595
Message-ID: <50939061.9060201@metafoo.de>
Date: Fri, 02 Nov 2012 10:20:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 7/8] serial: xilinx_uartps: get clock rate info from dts
References: <cover.1351721190.git.josh.cartwright@ni.com> <23a299ee5e89cfd17bb9affd8fbb9f41b79cfd46.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <23a299ee5e89cfd17bb9affd8fbb9f41b79cfd46.1351721190.git.josh.cartwright@ni.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:28 PM, Josh Cartwright wrote:
> Add support for specifying clock information for the uart clk via the
> device tree.  This eliminates the need to hardcode rates in the device
> tree.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi   |  4 ++--
>  drivers/tty/serial/xilinx_uartps.c | 30 +++++++++++++++++-------------
>  2 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index bb3085c..5fb763f 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -44,14 +44,14 @@
>  			compatible = "xlnx,xuartps";
>  			reg = <0xE0000000 0x1000>;
>  			interrupts = <0 27 4>;
> -			clock = <50000000>;
> +			clocks = <&uart_clk 0>;
>  		};
>  
>  		uart1: uart@e0001000 {
>  			compatible = "xlnx,xuartps";
>  			reg = <0xE0001000 0x1000>;
>  			interrupts = <0 50 4>;
> -			clock = <50000000>;
> +			clocks = <&uart_clk 0>;

Shouldn't this be <&uart_clk 1>?

>  		};
>  
>  		slcr: slcr@f8000000 {

