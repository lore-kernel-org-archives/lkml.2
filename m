Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2KMF4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:56:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab2KMF4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:56:30 -0500
Date: Tue, 13 Nov 2012 14:56:20 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Move chip reset to before register patch
Message-ID: <20121113055618.GC18224@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20121112175648.GA29044@opensource.wolfsonmicro.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 05:56:48PM +0000, Charles Keepax wrote:
> In the absence of a physical reset line the chip is reset by writing the
> first register, this was done after the register patch was applied which
> negates the settings applied in the register patch.
>=20
> This patch moves the reset to take place before the register patch is
> applied.

No, we should never write to the chip until we have successfully
identified it.  Do a sync or similar instead (we should be triggering
this very soon afterwards via runtime PM anyway).

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoeDJAAoJELSic+t+oim9yrgP/3CkNx6T7UVk8WtF/akflsWZ
nHV4+akHuFW3iLPinqzv3z4yaMYlO6CwuLfC91V476phkDcvuZ9MXFz/NWH0w2Oh
MnOXJHo/9TBkhd3r9U05FQppX7JeCHo53SfAa/J3xdwXS6agMDsN60uTZPQCfMZu
QYIaeBWwWZwvJk6wdTPb3ezovXuiFLCGOWYQb6YL4PiWRE9BC1yR3YaRb6n0+Hru
fgptBTU2lHqxzwj4BBuDP48ltir5bnVcdSqmV8S0m+p/p0o6dcWzWnFy4irmfy3I
ZCC5bl/ZlpKhtcIddJxd7PquwSB6D8ZJiuOUlZ5XY5xhvtfxBVvMSiQ/HxbmT20U
bpz5ZSCRYPGMVrYg7G++r+cO1Wr2Gkhvj918f6HT3Z/KVDCuKpUmtqU55Zaozu3j
W0I695dZ1dFlfbeLxV0XvKA7av3mes8w7qbTPc/Nar/aHnScVy8R8JAlZBOPtKa5
13baTEuFsIVqCSa99RezkLhMSOG0SlK2ivLK6Vo6t55GndMXl951+ZjkvIMcDbP/
2lkCHxIxerIFf35EoqpvRe5/gMfcPOVefKx6nm84gAw90dpXEia/uwVWCBX21P8E
qx6WatK2VnDEQNh2dZFDeybtR8WV3AMCv6y9S9Etie0z1xhfQwetjKztulvdfT2Z
HgYVdHpQtCbJmJlZCnsh
=4i9s
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
