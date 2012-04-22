Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2DVQUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:20:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50319 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2DVQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:20:34 -0400
Date: Sun, 22 Apr 2012 18:20:08 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 2/2] i2c/of: Automatically populate i2c mux busses
 from device tree data.
Message-ID: <20120422162008.GA4201@pengutronix.de>
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
 <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 12, 2012 at 02:14:23PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
>=20
> For 'normal' i2c bus drivers, we can call of_i2c_register_devices()
> and have the device tree framework automatically populate the bus with
> the devices specified in the device tree.
>=20
> This patch adds a common code to the i2c mux framework to have the mux
> sub-busses be populated by the of_i2c_register_devices() too.  If the
> mux device has an of_node, we populate the sub-bus' of_node so that
> the subsequent call to of_i2c_register_devices() will find the
> corresponding devices.
>=20
> It seemed better to put this logic in i2c_add_mux_adapter() rather
> than the individual mux drivers, as they will all probably want to do
> the same thing.

Both patches looking mostly good, two things here:

> +	/*
> +	 * Try to get populate the mux adapter's of_node, expands to

"get populate"? I'd think you mean "populate" only, but am not sure
enough to fix it myself.

> +	 * nothing if !CONFIG_OF.
> +	 */
> +	if (mux_dev->of_node) {
> +		struct device_node *child;
> +		u32 reg;
> +		int ret;

We have a "ret" already in this function.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+UL7gACgkQD27XaX1/VRvdWgCgrlnDJ86GWtEaT3obbXaiJfuW
q/YAoIzUvdOyNTDegA/3UfckWimXYdZv
=nwnH
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
