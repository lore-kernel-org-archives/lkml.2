Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2DTHk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:40:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35607 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2DTHk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:40:26 -0400
Date: Fri, 20 Apr 2012 09:40:15 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Robin Gong <B38343@freescale.com>, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/2] mfd: Add Freescale's PMIC MC34708 support
Message-ID: <20120420074015.GD31760@pengutronix.de>
References: <1334853521-23792-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334853521-23792-1-git-send-email-paul.liu@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:37:31 up 159 days, 15:24, 87 users,  load average: 1,03, 3,00,
 2,08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:38:40AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> diff --git a/Documentation/devicetree/bindings/mfd/mc34708.txt b/Documentation/devicetree/bindings/mfd/mc34708.txt
> new file mode 100644
> index 0000000..2bb5c9e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/mc34708.txt
> @@ -0,0 +1,61 @@
> +* Freescale MC34708 Power Management Integrated Circuit (PMIC)
> +
> +Required properties:
> +- compatible : Must be "fsl,mc34708"
> +
> +Optional properties:
> +- fsl,mc34708-uses-adc   : Indicate the ADC is being used
> +- fsl,mc34708-uses-rtc   : Indicate the RTC is being used
> +- fsl,mc34708-uses-ts    : Indicate the touchscreen controller is being used
> +
> +Sub-nodes:
> +- regulators : Contain the regulator nodes.  The MC34708 regulators are
> +  bound using their names as listed below for enabling.
> +
> +    mc34708__sw1a    : regulator SW1A
> +    mc34708__sw1b    : regulator SW1B
> +    mc34708__sw2     : regulator SW2
> +    mc34708__sw3     : regulator SW3
> +    mc34708__sw4A    : regulator SW4A
> +    mc34708__sw4b    : regulator SW4B
> +    mc34708__swbst   : regulator SWBST
> +    mc34708__vpll    : regulator VPLL
> +    mc34708__vrefddr : regulator VREFDDR
> +    mc34708__vusb    : regulator VUSB
> +    mc34708__vusb2   : regulator VUSB2
> +    mc34708__vdac    : regulator VDAC
> +    mc34708__vgen1   : regulator VGEN1
> +    mc34708__vgen2   : regulator VGEN2
> +
> +  The bindings details of individual regulator device can be found in:
> +  Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +Examples:
> +
> +i2c@63fc8000 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	compatible = "fsl,imx53-i2c", "fsl,imx1-i2c";
> +	reg = <0x63fc8000 0x4000>;
> +	interrupts = <62>;
> +	status = "okay";
> +
> +	pmic: mc34708@8 {
> +		compatible = "fsl,mc34708";
> +		reg = <0x08>;
> +
> +		regulators {
> +			mc34708__sw1a {
> +				regulator-min-microvolt = <650000>;
> +				regulator-max-microvolt = <1437500>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			mc34708__vusb {
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +		};
> +	};
> +};

The oftree parts should be discussed on devicetree-discuss.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
