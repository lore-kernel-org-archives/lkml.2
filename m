Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2DDW7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:59:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43504 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757355Ab2DDW7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:59:20 -0400
Date: Wed, 4 Apr 2012 23:59:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 4/6] regmap: add MMIO bus support
Message-ID: <20120404225915.GH10787@opensource.wolfsonmicro.com>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
 <1333576113-13196-4-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Content-Disposition: inline
In-Reply-To: <1333576113-13196-4-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X+8siUETKMkW99st
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 03:48:31PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> This is a basic memory-mapped-IO bus for regmap. It has the following
> features and limitations:

I applied these up to here but it was painful as patch 2 didn't apply
cleanly to -rc1 and git am couldn't find the blobs to use for
resolution.  Please check things worked out OK but I'm pretty sure they
did.

> * Registers themselves may be 8, 16, 32, or 64-bit. 64-bit is only
>   supported on 64-bit platforms.
> * Register offsets are limited to precisely 32-bit.
> * IO is performed using readl/writel, with no provision for using the
>   __raw_readl or readl_relaxed variants.

Also limited native endian register I/O.  It would have been much better
to fix this in the core - please consider producing followup patches to
push the code there, though it's far from essential.

> +static int regmap_mmio_gather_write(void *context,
> +				    const void *reg, size_t reg_size,
> +				    const void *val, size_t val_size)
> +{
> +	struct regmap_mmio_context *ctx =3D context;
> +	u32 offset;
> +
> +	if (reg_size !=3D 4)
> +		return -EIO;

Given that you constrain on registration too this should be BUG_ON(),
we're seriously confused if we're specifying a different register size
here and -EIO is going to be a bit obscure.

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfNI9AAoJEBus8iNuMP3dvj8P/REHv/KcUzhi81W7nYuxaxJI
Kc92GLGUVg/Mdg9oB83IsDDZpTaM8tSXfJHXCARYs7QoEKRGe1nZi5v/pza33r0u
hSwuIIlK2paOfTeGsrXQIThmZJr51W3OMOBhTn0LGZylGL8EEyLgSMz7J2qdnPMF
5mcjUuFG4VO2Xk5+Hd4jAOgTo2u5wwB9UXrcZy9uq/efc9MYHAGvDqXRUDiwKy57
kswdG/07LvzYQDTrLO6yMBDEwekZy9ajLl9IEfw/eRTEoiT1wxHXMyApHkuyCGdx
A2I2r+adFvd0wIAQ2DQCw+CrbZrl9J3AXKG7IuUMlpw9jU8pdv57vCIpMALCYbqj
u3nAd9lSCqB5kfzBUPhcl05Xf8RIFUMXC/9GdYLcm7RiMzEl8/nmogdjX48kZjI2
G0qkJz3Uw10NkXMpounRh7Ffq8B2seCqMCGzO/McGDsEeEwnVUenU1wD/tDS79wc
lp7wj7SxVTlXXbtnLec0H5kvacZ57Z1emirV46T5wrbDV26Vlfpl1SWraR218uVG
EnRc397UixLDH8ToZZ+Neucf9vGnCsf8xnBgIMJdzK89AED9VvGzJdQ+Mllpts81
Tva/dl3WH/3P4RuRJ/kuAqLv9bLSsx8fvK9+RKh2AJkST/3RgelNAz+LaQJ6TxWN
0YayA7cqP89aJvMZaAUA
=zA3g
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
