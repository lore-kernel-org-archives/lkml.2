Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab2EWRgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:36:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48541 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760659Ab2EWRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:36:21 -0400
Date: Wed, 23 May 2012 18:36:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: marc@cpdesign.com.au, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120523173617.GC4064@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
 <CAOMZO5DKLO5B7vbMKmXLfmR0zgVX5bVcxK22khTt=X71bL5tOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DKLO5B7vbMKmXLfmR0zgVX5bVcxK22khTt=X71bL5tOQ@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 23, 2012 at 11:18:10AM -0300, Fabio Estevam wrote:

> #define MC13XXX_REGOFFSET_SHIFT 25
> int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *v=
al)
> {
> 	struct spi_transfer t;
> 	struct spi_message m;
> 	int ret;
>=20
> 	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
>=20
> 	if (offset > MC13XXX_NUMREGS)
> 		return -EINVAL;
>=20
> 	*val =3D offset << MC13XXX_REGOFFSET_SHIFT;

> ,would the spi regmap access take into account this
> MC13XXX_REGOFFSET_SHIFT operation?

The data sent should be however many bits of register address are
specified, followed by however many padding bits are specified, followed
by the data.  The shift there will be some combination of the padding
and register address.

Though if the device is looking for everything byte swapped for some
insane reason...

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvSAKAAoJEBus8iNuMP3d8yEP/RLMvuuszeWMeLmYX5ghrQcK
0OZgRfKVjOgpwDGiDiFN+htBke4DFps8lTYWgTjAajNBvMj7ul4XxYTlbghrWOrw
JTRz5kjh8SIEA0s/FkMq/mnbegJebaMvmeYP5Yzc9eK0CTeahbF5RIGi3eaki7Ye
oeUPQioj6OgIwT5hv6fSAe2vVn40fSmwUTUWc9FZqAIjhBAu8X/n5G9RDgZdHsP3
dLvLN6s+YAiuYkYg8BfsFcBaEWttaOjEednsDQLaJuA32aBWbcLh1zN2V5IJhTib
SxWC/vvn3934MycyF+LISt2wWkWyIYl5whaec8QAvu/1OCNi5f7Noq0iWv7+t6i+
s07emfAI3hIyqPw7EMzHTGRjpknt4lDhXIptfb1t/Rvf4g6EE18l1HyIWE6jKsZl
874K3vhYdJqFKVPd9MLlM+gnPXMEnrAyhw9FjLiwZyMyKJEllFFj4BNv+kvqxmT6
JFvyfbzKMtMfaFyW1cz0TfnHHHvxZdO8+DsXoy1BGShLWzgoFSrQEewZqfSDzqsZ
bDGeTGFhpz8xJNrDTMOhBT/lbrsJgoJwxiAJwailii/Aqdst7e1sjyRaUaOe0TKJ
wOTb97g2XgKWJt8ndOj57gE1XO4SSGomPeu6RRx+/VUZVmUlc/vsJfCLe0Diy23r
OE4u3l+dv6lcfyL+xFoB
=NPoV
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
