Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2EIKOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:14:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54206 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629Ab2EIKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:14:33 -0400
Date: Wed, 9 May 2012 11:14:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V1] regulator: fixed: dt: add property for gpio open
 drain flag
Message-ID: <20120509101428.GE3955@opensource.wolfsonmicro.com>
References: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com>
 <4FA7E4A3.6050004@wwwdotorg.org>
 <4FA7E57B.30804@nvidia.com>
 <4FA7E841.7020100@wwwdotorg.org>
 <20120507162419.GK17002@opensource.wolfsonmicro.com>
 <4FA98F78.4080803@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <4FA98F78.4080803@wwwdotorg.org>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 03:26:16PM -0600, Stephen Warren wrote:
> On 05/07/2012 10:24 AM, Mark Brown wrote:

> > It's really not idiomatic for drivers using GPIOs to allow
> > configuration of their flags in the first place.  Or, quite
> > frankly, to use flags. Honestly I'd not expect any bindings that
> > the GPIO driver provides to have any attention at all paid to them
> > most of the time, looking at the code seems to support that (though
> > there's surprisingly few bindings using GPIOs at all it seems).

> So, are you saying we should remove the flags from the GPIO bindings,
> and do something custom in each consumer?

Not really, it's more internal Linux stuff with the gpio API being a bit
stuck.

> Right now, we can't rely on of_get_gpio_flags(), since not all GPIO
> drivers actually allow flags to be represented in bindings.

> However, having each client have a unique binding for things like
> open-drain, inverted, ... seems bad; there are probably fewer
> providers than consumers, although a single standardized

It really depends what the device is doing with the GPIO, we would at
least need to have a way for the user to get the flags back out in case
the configuration is important for what it does.  Most of this stuff is
going to be nonsensical for most uses anyway, though, and obviously
there's the whole middleware emulation thing as well.

> representation might admittedly have been ever better.

Well, that's legacy device tree stuff for you :/

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqkN9AAoJEBus8iNuMP3dW8cP/iVw2Do0tUScVvgtfYf25cHn
JMLmX51fRmkKBp03FxdLVGkecHZmBPKBi48JSLD3hW1r81IydjhGFH/5LUrK3mmt
wQxEHOo4iHH2kwfHtINdMu9FT3q52+iCd02jNBABLc8hlRwm6BIXCDdzdHdNKKxl
6VWUvHkfGaNu/vfZOE/6oqpQbGqLwjdrSmsaosNB4V22+buISbx7D0A40ph/ZZqL
T3XvbrIG8ZcE4DXWwz38iTLSr1J4UbUuyKtjugSsOQmIHoYKZ447E/vH3YsXPHoC
AFY2dEZkZ8cMzVgbxFEoHJR80BxZpEuNCVhV6xcX7U+3wGxVzMVIFoqELBRg3FlS
0fw+yCsS1b0u7hw6HzKmKSgpMK1J95vrDg6i+//Rh+wg0Rre1p2jPd7oSsjcHqvm
1KlYe3Hvo0usoZJetKVMzWqmGlj0/VWU0QTDGXn5gVL85v39DFBCPXDe3l+Pj6/p
X3FfUzQKAry9cfq/okgQH5nC3Y8ncMllEmS+iTW7EweA/6P1iC5aBmroaElYhMsm
Oz0TDbNiHuKsqW5QxqHzoxs1PNPtwp3KxNSpg+RarMdVcJK68vgbVSVXU2xB4lYS
QrPdg++vMORGDTNIGtHSVFGxWzNi7B36ohGjKU7CT8Ce+zVDMro8ETG/mt+kgtMT
/0kduD0Okzsdhy6XYBfH
=QoqK
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
