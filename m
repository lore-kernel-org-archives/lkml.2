Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2KTOsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:48:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43970 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2KTOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:48:44 -0500
Message-ID: <50AB9832.90709@ti.com>
Date: Tue, 20 Nov 2012 16:48:18 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigF62DFAACA269378853BB95CC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigF62DFAACA269378853BB95CC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-17 12:55, Alexandre Courbot wrote:

A few questions after looking at the documentation:

> +Example
> +-------
> +Here are example sequences declared within a backlight device that use=
 all the
> +supported resources types:
> +
> +	backlight {
> +		compatible =3D "pwm-backlight";
> +		...
> +
> +		/* resources used by the power sequences */
> +		pwms =3D <&pwm 2 5000000>;
> +		pwm-names =3D "backlight";
> +		power-supply =3D <&backlight_reg>;
> +
> +		power-sequences {
> +			power-on {
> +				step0 {
> +					type =3D "regulator";
> +					id =3D "power";
> +					enable;
> +				};
> +				step1 {
> +					type =3D "delay";
> +					delay =3D <10000>;
> +				};
> +				step2 {
> +					type =3D "pwm";
> +					id =3D "backlight";
> +					enable;
> +				};
> +				step3 {
> +					type =3D "gpio";
> +					gpio =3D <&gpio 28 0>;
> +					value =3D <1>;
> +				};
> +			};

I guess there's a reason, but the above looks a bit inconsistent. For
gpio you define the gpio resource inside the step. For power and pwm the
resource is defined before the steps. Why wouldn't "pwm =3D <&pwm 2
5000000>;" work in step2?

> +When a power sequence is run, its steps is executed one after the othe=
r until
> +one step fails or the end of the sequence is reached.

The document doesn't give any hint of what the driver should do if
running the power sequence fails. Run the "opposite" power sequence?
Will that work for all resources? I'm mainly thinking of a case where
each enable of the resource should be matched by a disable, i.e. you
can't call disable if no enable was called.

 Tomi



--------------enigF62DFAACA269378853BB95CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQq5gyAAoJEPo9qoy8lh71Q4wP/ishGG4j6CsP9aN9+MiI8HCA
N1SS7vzaR8ozlor2yF2GuRmtQKHOavOV2k/GRoVB2ewdsJSpcuijyHELfXC+M4re
vxdkhawlkWKn+xC8pNBMoWrhUZFKeo9/Xk7dTpxXaweKTvGzmIPHSiAZn62jvV7C
ZEIafQqkOAtEVKI7GrDAXqSObNyUgA2ASP9VLAu6nRq3PpoYRqQtrRP1lGP9naCp
xkYUYDoXzAAyjIw0nnyMDLtgex0KEpA10vTMknMbFOhB34cSATI13saZdhtEnLOl
G9qo3m7eYAYfg5cngFINB80pJ5pv7frZwwsJZ2miUDOykw/PJpSk2RpQA1CxjqBC
4yJkPPY7gbQQXh5G64BxoIuNEI4zVlJVfAzyTuurqJ0gRhmwdSz8AbRObAeT2Mbw
YiDmk6xV8v+LP6nJzSAeOtV0+CJwz3BaCJMqfANkNsUoK/J5Ikr5I00KhPB4lCdM
pPYVOHEh7fi9KcZnnJBH5vjEFZnP9x5ukLZbc/vdfukvQSg/yvL6NwZPoE5ZY56i
Ojgy71IZ8K0HmJekmr0Ejlp7PLXl0XP2qZfDSX7FHey+ogCh7FKRcmEIgaun5ffw
Ddm3t1QWZq1j/8Ht8Uy08BOOyrp48L7sHjrAUx38H9m7eTQKznJD0gPwqcfBwZju
n4XHo9Z32v3RbP8Ht1EF
=4xsL
-----END PGP SIGNATURE-----

--------------enigF62DFAACA269378853BB95CC--
