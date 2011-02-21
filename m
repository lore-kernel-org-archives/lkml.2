Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1BULWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:22:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49877 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1BULWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:22:44 -0500
Date: Mon, 21 Feb 2011 12:22:40 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Eric Miao <eric.y.miao@gmail.com>,
        Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110221112240.GH2616@pengutronix.de>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
 <201102211037.19572.alexander.stein@systec-electronic.com>
 <20110221094756.GC2616@pengutronix.de>
 <201102211207.29291.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ijf6z65S790CMqo8"
Content-Disposition: inline
In-Reply-To: <201102211207.29291.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ijf6z65S790CMqo8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 21, 2011 at 12:07:27PM +0100, Alexander Stein wrote:
> On Monday 21 February 2011, 10:47:56 Wolfram Sang wrote:
> > > We had exported our 5V_enable gpio to sysfs to allow a user-space
> > > application to enable/disable devices connected to 5V circuit.
> > > But on the other hand we had to read the current status of this gpio =
in
> > > the power-fail interrupt handler to distinguish between false-positive
> > > (5V disabled) and a correct detection.
> >=20
> > What about gpio_export() (description in Documentation/gpio.txt)?
>=20
> Ah, I didn't know about this. I just expected this is only used from sysf=
s=20
> part. But you have to make sure your .ko is loaded before userspace is=20
> accessing sysfs and tries to export the GPIO.

Eh? Userspace doesn't export the GPIO in that case.

> Or is it "allowed" by the API convention to gpio_request and gpio_export =
(and=20
> set direction) a GPIO in the machine startup code which will later be use=
d in=20
> a different place?

different place =3D userspace? Well, that's the main intention of
gpio_export(). (I have the feeling we are missing each other here,
thoguh) I'd suggest looking a bit further in the docs/code. It should
make clear what is possible.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ijf6z65S790CMqo8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1iSwAACgkQD27XaX1/VRvmvgCguZFE+2aYVBj26SVTxeQR8P0A
5REAn03ch7si/7FjCxW2/BuA2lVW823B
=jJuS
-----END PGP SIGNATURE-----

--ijf6z65S790CMqo8--
