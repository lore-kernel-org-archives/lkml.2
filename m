Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2DRFq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:46:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2DRFqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:46:24 -0400
Date: Wed, 18 Apr 2012 07:46:15 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 7/8] ARM: LPC32xx: DTS files for device tree conversion
Message-ID: <20120418054615.GB17506@avionic-0098.adnet.avionic-design.de>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <1334682507-15055-8-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <1334682507-15055-8-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:nTkknjzOR5TmG1gDNLZmNasx8zca17m6DsJSx+vOW0z
 treavdjRKGgWm36mj67any40QADodh+xTQzyaCufkFE0Kx7Z2k
 1drDOrgHd2pGDOBXYg+2jSV6Bm8cIf+hyVMi6gNxbSqOKfeKjp
 jfuD2SdaKrSgDONk0rXNBYjmo7VCSBJc2NATMKPS94n8N5xG+8
 eus7MuU26dFT+2WEhoTQrf/1Cu5i3Jicm3TOlGvyjpm1pUUKVg
 U4/peKehjAuTLmc3XZbTjAE6BIop/XOUlwWyx4enxavHjxzdYJ
 HG8nhTls9e5QhoE/MxU0hv9BktArrxRd/B+v9/5dv0k+RzvITz
 TnhUYWEISxCFhx/xmUezwWl5mGTBrq9E5eqZZmwyJkzahp0lWU
 Fo1JHJz/OHc3lHLk8wUQx4MlF6jy1I5U5g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Roland Stigge wrote:
[...]
> --- /dev/null
> +++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
> @@ -0,0 +1,303 @@
> +/*
> + * NXP LPC32xx SoC
> + *
> + * Copyright 2012 Roland Stigge <stigge@antcom.de>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	compatible = "nxp,lpc32xx";
> +
> +	cpus {
> +		cpu@0 {
> +			compatible = "arm,arm926ejs";
> +		};
> +	};
> +
> +	ahb {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "simple-bus";
> +		ranges = <0x20000000 0x20000000 0x30000000>;
> +
> +		slc: flash@20020000 {
> +			compatible = "nxp,nand-slc";
> +			reg = <0x20020000 0x1000>;
> +			status = "disable";
> +		};
> +
> +		mlc: flash@200B0000 {
> +			compatible = "nxp,nand-mlc";
> +			reg = <0x200B0000 0x1000>;
> +			status = "disable";
> +		};
> +
> +		dma@31000000 {
> +			compatible = "arm,pl080", "arm,primecell";
> +			reg = <0x31000000 0x1000>;
> +			interrupt-parent = <&mic>;

Most platforms define the interrupt parent somewhere in the top-level node
and have it inherited for child devices instead of having to repeat it for
each device. But I guess it's also okay to make it explicit.

[...]
> +			/*
> +			 * MIC Interrupt controller includes:
> +			 *   MIC @40008000
> +			 *   SIC1 @4000C000
> +			 *   SIC2 @40010000
> +			 */
> +			mic: interrupt-controller@40008000 {
> +				compatible = "nxp,lpc32xx-mic";
> +				interrupt-controller;
> +				interrupt-parent;

I /think/ in this case you can leave this out. At least there doesn't seem to
be any other such usage in the tree.

Thierry

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+OVScACgkQZ+BJyKLjJp/+9wCgqaNqeJvdY9/+vc48JNRs3lGp
josAnjaYrWXh5YY6WRM/mUHvVlIhj1kX
=rxOt
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
