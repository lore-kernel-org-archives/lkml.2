Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab2J1SPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:15:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52302 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab2J1SPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:15:44 -0400
Date: Sun, 28 Oct 2012 18:15:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Regulator: core: Unregister when gpio request fails.
Message-ID: <20121028181540.GC4547@opensource.wolfsonmicro.com>
References: <1351436471-17210-1-git-send-email-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <1351436471-17210-1-git-send-email-andrew@lunn.ch>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 28, 2012 at 04:01:11PM +0100, Andrew Lunn wrote:
> If the gpio_request_one() fails, or returns EPROBE_DEFER, the
> regulator must be device_unregister()ed. When this is not done,
> there are WARNING: from sysfs:
>=20
> WARNING: at fs/sysfs/file.c:343 sysfs_open_file+0x238/0x268()

Applied, thanks.  Please remember to submit patches with subject lines
that match the subsystem.  Also

> +                       goto wash;

that's a bit too cute and is going to hurt maintainability, meaningful
names are helpful when you get a bunch of things (eg, "clean_gpio").

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjXYxAAoJELSic+t+oim9zOcP/3h6PQU1wfLq0UquEdlZDu/F
0Ra2rRSx3excBobqTB6/Co3VIyAys2+7tcwA/1Qj4EG4sIi6m3cd3ZkeNF0q+bZg
kbOs8658tlEoReR8dsKFBQtloisUFO7aANpXsFeutaiJUWJ/umf6UeaMxb4h9qHv
4SVppth+jMsiNIE9Gf6ARniIysYOj9KbDHWXnKPvRKolmsW6zDyx++9dYHbCxOWk
lKMHOVIS/IBP2BOf4yVCbZfkgiSYdvt75Gj3FDYA0b0/OoxNa7dYJj1J4SGJOXVi
hyxCyyp0+X37Htj8cS2sBl/hFLFpRYrnaAhhBRoWj7Q0kKesLqUm38YJXI35cF+O
RROyLjfht36XBajt0ZauqRpf5Qy5WzVbwWYYURQEy1cCIguIx/N84jjI+sZAuzZv
l38XqOqifwCBvjE2sZxoSMOWbl7zA5wyOvdld427+nV6UFl3JUID4b6hea/eCtoD
yff6vhzNbTQLY5K63Sf8jmFW7vJICo8/CvPtSKn4lVU0TjGV6J5cUKXbOx/8Ab5Y
TMOCeboHh14LwIlXojdThZRiGinvPvbZRpzqI9vPa0xrtGR59MEzVjlIyAYDtIW6
XYUB1ZtRmaj5KaIzcztJgG7NqIYvT381usraj5t0TujkCepHtsJnMqEDj8yKyBCX
EHASSoxPDFavW5xxFIt3
=QJUb
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
