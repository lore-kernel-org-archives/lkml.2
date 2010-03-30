Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0C3MfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:35:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48056 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0C3MfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:35:20 -0400
Date: Tue, 30 Mar 2010 14:35:18 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 06/24] input/keyboard: fix dangling pointers
Message-ID: <20100330123518.GG29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-7-git-send-email-w.sang@pengutronix.de> <20100320192007.GA28402@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cgrdyab2wu3Akvjd"
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


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

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
>=20
> I will apply lm8323 portion of the patch but leave qt2160 as is.

We reached an agreement that a) setting the clientdata-pointer to NULL shou=
ld
be done in the i2c-core [1] and b) how to do it. Based on that, I will do t=
he
modification of the i2c-core for 2.6.34 (as it fixes the dangling pointers)=
 and
then create one single patch removing the then superflous calls to
i2c_set_clientdata for 2.6.35 (as it is a cleanup). As you already applied =
the
above patch to your branch: you don't have to revert, we will fix it for yo=
u in
the next round.

Sorry for the detour!

Kind regards,

   Wolfram

[1] http://thread.gmane.org/gmane.linux.drivers.i2c/5674/focus=3D5729

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Cgrdyab2wu3Akvjd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux8AYACgkQD27XaX1/VRs9oQCdEDKK0ngsZhgFzOhzRWf3QtE2
NlQAn24Dj6voGeer6H30RiDpUyNBAWbU
=oY6l
-----END PGP SIGNATURE-----

--Cgrdyab2wu3Akvjd--
