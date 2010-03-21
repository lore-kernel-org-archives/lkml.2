Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab0CUB7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 21:59:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33419 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0CUB72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 21:59:28 -0400
Date: Sun, 21 Mar 2010 02:59:26 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 06/24] input/keyboard: fix dangling pointers
Message-ID: <20100321015925.GA26625@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-7-git-send-email-w.sang@pengutronix.de> <20100320192007.GA28402@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20100320192007.GA28402@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dmitry,

On Sat, Mar 20, 2010 at 12:20:07PM -0700, Dmitry Torokhov wrote:
> Hi Wolfram,
>=20
> On Sat, Mar 20, 2010 at 03:12:47PM +0100, Wolfram Sang wrote:
> > Fix I2C-drivers which missed setting clientdata to NULL before freeing =
the
> > structure it points to. Also fix drivers which do this _after_ the stru=
cture
> > was freed already.
> >=20
>=20
> I am not sure if setting clientdata to NULL before freeing the data is
> that important; we really want to be sure that we don't leave clientdata
> dangling when we finish unbinding the driver. If there are another
> thread the change will not really help the problem of accessing
> non-existing client data.

I agree it won't matter in practice. Jean and I concluded it is better
style, though (http://comments.gmane.org/gmane.linux.drivers.i2c/5392).
Still, I will not insist and leave it up the subsystem maintainers, of
course. I also won't check for that case again in the future.

> I will apply lm8323 portion of the patch but leave qt2160 as is.

Thanks!

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkulfX0ACgkQD27XaX1/VRtgIwCeP3ARt+wII1Xeva9Lnytebcsr
IQcAnApsmX1e9BfUoF/0kyJ4U7XWnSgu
=lIAk
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
