Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2KTGFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:05:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36223 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab2KTGFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:05:20 -0500
Date: Tue, 20 Nov 2012 15:05:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: introduce tables for
 readable/writeable/volatile/precious checks
Message-ID: <20121120060509.GB10560@opensource.wolfsonmicro.com>
References: <1353331913-24941-1-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1353331913-24941-1-git-send-email-ciminaghi@gnudd.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 02:31:53PM +0100, Davide Ciminaghi wrote:
> Many of the regmap enabled drivers implementing one or more of the
> readable, writeable, volatile and precious methods use the same code
> pattern:
>=20
> 	return ((reg >=3D X && reg <=3D Y) || (reg >=3D W && reg <=3D Z) || ...)
>=20
> Switch to a data driven approach, using tables to describe
> readable/writeable/volatile and precious registers ranges instead.
> The table based check can still be overridden by passing the usual functi=
on
> pointers via struct regmap_config.

Sorry, the code looks good but I just realised we already have a feature
called ranges - the paged window support also calls the regions it uses
ranges.  Can I suggest access_table or similar instead?  Sorry about
that - I should've realised.

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqx1rAAoJELSic+t+oim9PNEP/i21jOTC70YD5ahZUilvKT2w
+aGXOqj0jenEln7vKoWjGmz8rHgY4e/9ZlHXojiGLmJDWqI9bn3y1XLKL6dmtgE0
XQh8XxkKfLqtvTLZYEBqJc5Jy/JpzMBh9NOAFbITz8OfjiE346tO8ZS7qQ+NmCdd
vyneSrD3e5XnDne1hqZFxMz5xgT8/J9GAnlFzEWwtuW5TvUUjBO28/hxiKBi5ZOJ
na3oQ/fSCP3hTNiBmdvV58eHpicCSTdsDw+FJvqz5It9o6o1w4WirDYLmpxUeLU+
X9iQhCWFvNWj9C8uDrbl2XFahwWOn9L/4lO3oHt4zfEi70Ojd9Df77jgmrg2T5DS
xbYjxeNcK5PLYFANmwplA0o5qqhucDK3LY171mZJ/EBfpvhR3RQCgcnStblUjJVs
0gq8EuBnkxjR+1Uq060gAYigp4iRBg60iq2Wi0ZGaZT6M4I8E18GX0nCYsm7iuJh
GabIctNvhHo5iKyLg76y2wQWUMNsEP7Zy3rKZHCxNfepdfuwACPIgSbwFuGhzFMG
wCbcXo5qeZMNEYi/Pf3PZ7RNH9xBS3FkoNkjHYvzxwY+f6RWfz7mcNGSrDO2WeSO
k1WDFHvUs6c3IPujHBFTRM/vNsruq+l7dLkIDlYA1gN6Zq0FJqdixssxOoIMOJCi
aH0z3aWgwHXNG2OHNSZo
=dvLX
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
