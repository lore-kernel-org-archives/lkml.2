Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2KMIwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:52:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42420 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2KMIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:52:23 -0500
Date: Tue, 13 Nov 2012 09:52:21 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Philippe Reynes <tremyfr@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        julien.boibessot@armadeus.com, eric.jarrige@armadeus.org
Subject: Re: [PATCH v4] Add device tree file for the armadeus apf27
Message-ID: <20121113085221.GE10369@pengutronix.de>
References: <1352752113-21978-1-git-send-email-tremyfr@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352752113-21978-1-git-send-email-tremyfr@yahoo.fr>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:52:08 up 143 days, 3 min, 85 users,  load average: 0.29, 1.39,
 2.43
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 09:28:33PM +0100, Philippe Reynes wrote:
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> Signed-off-by: Eric Jarrige <eric.jarrige@armadeus.org>
> ---
> 
> v4: update model to use the same format as apf28
>     remove some empty line
> v3: set 26M clock to 0 (not used)
> v2: avoid enable again the watchdog
> 
>  arch/arm/boot/dts/imx27-apf27.dts |   89 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/imx27-apf27.dts

Applied, thanks

Sascha

> 
> diff --git a/arch/arm/boot/dts/imx27-apf27.dts b/arch/arm/boot/dts/imx27-apf27.dts
> new file mode 100644
> index 0000000..c0327c0
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx27-apf27.dts
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright 2012 Philippe Reynes <tremyfr@yahoo.fr>
> + * Copyright 2012 Armadeus Systems <support@armadeus.com>
> + *
> + * Based on code which is: Copyright 2012 Sascha Hauer, Pengutronix
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/dts-v1/;
> +/include/ "imx27.dtsi"
> +
> +/ {
> +	model = "Armadeus Systems APF27 module";
> +	compatible = "armadeus,imx27-apf27", "fsl,imx27";
> +
> +	memory {
> +		reg = <0xa0000000 0x04000000>;
> +	};
> +
> +	clocks {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		osc26m {
> +			compatible = "fsl,imx-osc26m", "fixed-clock";
> +			clock-frequency = <0>;
> +		};
> +	};
> +
> +	soc {
> +		aipi@10000000 {
> +			serial@1000a000 {
> +				status = "okay";
> +			};
> +
> +			ethernet@1002b000 {
> +				status = "okay";
> +			};
> +		};
> +
> +		nand@d8000000 {
> +			status = "okay";
> +			nand-bus-width = <16>;
> +			nand-ecc-mode = "hw";
> +			nand-on-flash-bbt;
> +
> +			partition@0 {
> +				label = "u-boot";
> +				reg = <0x0 0x100000>;
> +			};
> +
> +			partition@100000 {
> +				label = "env";
> +				reg = <0x100000 0x80000>;
> +			};
> +
> +			partition@180000 {
> +				label = "env2";
> +				reg = <0x180000 0x80000>;
> +			};
> +
> +			partition@200000 {
> +				label = "firmware";
> +				reg = <0x200000 0x80000>;
> +			};
> +
> +			partition@280000 {
> +				label = "dtb";
> +				reg = <0x280000 0x80000>;
> +			};
> +
> +			partition@300000 {
> +				label = "kernel";
> +				reg = <0x300000 0x500000>;
> +			};
> +
> +			partition@800000 {
> +				label = "rootfs";
> +				reg = <0x800000 0xf800000>;
> +			};
> +		};
> +	};
> +};
> -- 
> 1.7.4.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
