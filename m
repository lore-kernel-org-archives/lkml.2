Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959Ab2J2VKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:10:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48713 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2J2VKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:10:18 -0400
Date: Mon, 29 Oct 2012 22:10:15 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Philippe Reynes <tremyfr@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        julien.boibessot@armadeus.com, eric.jarrige@armadeus.org
Subject: Re: [PATCH] Add device tree file for the armadeus apf27
Message-ID: <20121029211015.GX1641@pengutronix.de>
References: <1351268980-25347-1-git-send-email-tremyfr@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351268980-25347-1-git-send-email-tremyfr@yahoo.fr>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:04:49 up 128 days, 12:16, 39 users,  load average: 0.32, 0.46,
 0.42
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 06:29:40PM +0200, Philippe Reynes wrote:
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> Signed-off-by: Eric Jarrige <eric.jarrige@armadeus.org>
> ---
>  arch/arm/boot/dts/imx27-apf27.dts |   96 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 96 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/imx27-apf27.dts
> 
> diff --git a/arch/arm/boot/dts/imx27-apf27.dts b/arch/arm/boot/dts/imx27-apf27.dts
> new file mode 100644
> index 0000000..b7d11e0
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx27-apf27.dts
> @@ -0,0 +1,96 @@
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
> +	model = "Armadeus apf27";
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
> +			clock-frequency = <33554432>;

Is this really correct? The Datasheet specificies 26MHz, some boards
have 27Mhz, but 33?

> +		};
> +	};
> +
> +	soc {
> +		aipi@10000000 {
> +			wdog@10002000 {
> +				status = "okay";
> +			};

This node is not necessary. The watchdog is enabled already in the dtsi
file.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
