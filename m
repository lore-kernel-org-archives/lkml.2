Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2HaLc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:32:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46662 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2HaLc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:32:27 -0400
Date: Fri, 31 Aug 2012 06:32:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: [PATCH 8/9] ARM i.MX53: Add pwms to dtsi
Message-ID: <20120830223219.GF3613@r65073-Latitude-D630>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:48:23PM +0200, Sascha Hauer wrote:
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Conflicts:
> 	arch/arm/mach-imx/clk-imx51-imx53.c

Yeah, I know you have sorted out conflicts :)

> ---
>  arch/arm/boot/dts/imx53.dtsi        |   14 ++++++++++++++
>  arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
> index cd37165..7ec17e4 100644
> --- a/arch/arm/boot/dts/imx53.dtsi
> +++ b/arch/arm/boot/dts/imx53.dtsi
> @@ -189,6 +189,20 @@
>  				status = "disabled";
>  			};
>  
> +			pwm1: pwm@53fb4000 {
> +				#pwm-cells = <3>;

pwm-cells should be 2?

> +				compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
> +				reg = <0x53fb4000 0x4000>;
> +				interrupts = <61>;
> +			};
> +
> +			pwm2: pwm@53fb8000 {
> +				#pwm-cells = <3>;
> +				compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
> +				reg = <0x53fb8000 0x4000>;
> +				interrupts = <94>;
> +			};
> +
>  			uart1: serial@53fbc000 {
>  				compatible = "fsl,imx53-uart", "fsl,imx21-uart";
>  				reg = <0x53fbc000 0x4000>;
> diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
> index 4bdcaa9..b522411 100644
> --- a/arch/arm/mach-imx/clk-imx51-imx53.c
> +++ b/arch/arm/mach-imx/clk-imx51-imx53.c
> @@ -455,6 +455,10 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
>  	clk_register_clkdev(clk[ssi1_ipg_gate], NULL, "63fcc000.ssi");
>  	clk_register_clkdev(clk[ssi2_ipg_gate], NULL, "50014000.ssi");
>  	clk_register_clkdev(clk[ssi3_ipg_gate], NULL, "63fd0000.ssi");
> +	clk_register_clkdev(clk[pwm1_ipg_gate], "ipg", "53fb4000.pwm");
> +	clk_register_clkdev(clk[pwm1_hf_gate], "per", "53fb4000.pwm");
> +	clk_register_clkdev(clk[pwm2_ipg_gate], "ipg", "53fb8000.pwm");
> +	clk_register_clkdev(clk[pwm2_hf_gate], "per", "53fb8000.pwm");

It should be in a separate patch?

>  
>  	/* set SDHC root clock to 200MHZ*/
>  	clk_set_rate(clk[esdhc_a_podf], 200000000);
> -- 
> 1.7.10.4
> 

-- 
Regards,
Shawn
