Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab2HVIxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:53:09 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30527 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880Ab2HVIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:52:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Wed, 22 Aug 2012 16:52:36 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@linaro.org>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>,
        <paul.liu@linaro.org>
Subject: Re: [PATCH 6/7] ARM: dts: imx6q: add simple-bus compatible string
 for anatop
Message-ID: <20120822085236.GK4011@b20223-02.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-7-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1345619928-15446-7-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:18:47PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Originally the anatop regulator devices are populated by mfd anatop driver.
> Since mfd anatop driver will be deleted later, we change to populate the
> regulator devices by devicetree automatically.
> This will cause some warning messages as follows during boot due to device
> recreation: "vdd1p1: Failed to create debugfs directory"
> But it does not break any function.
> Later, we will remove mfd anatop driver which can get rid of this
> error message.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  arch/arm/boot/dts/imx6q.dtsi |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index 7076be0..426f735 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -379,7 +379,7 @@
>  			};
>  
>  			anatop: anatop@020c8000 {
> -				compatible = "fsl,imx6q-anatop", "fsl,imx-syscon";
> +				compatible = "fsl,imx6q-anatop", "fsl,imx-syscon", "simple-bus";
To prevent bisect break, it should merge with patch #4.
It's really strange to use simple-bus, because it's not a bus.
I like more the way how anatop driver handle it. Anatop driver populate
devices in its code.

Thanks
Richard
>  				reg = <0x020c8000 0x1000>;
>  				interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
>  
> -- 
> 1.7.0.4
> 

