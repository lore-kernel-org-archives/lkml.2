Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab1DNCy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:54:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47105 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758683Ab1DNCy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:54:58 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>, Alex Elder <aelder@sgi.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110413155144.895499184@clark.kroah.org>
References: <20110413155144.895499184@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-nQoxiCZVjwEmDegYsNt3"
Date: Thu, 14 Apr 2011 03:54:45 +0100
Message-ID: <1302749686.5282.659.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [18/74] xfs: prevent leaking uninitialized
 stack memory in FSGEOMETRY_V1
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nQoxiCZVjwEmDegYsNt3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-13 at 08:50 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Dan Rosenberg <drosenberg@vsecurity.com>
>=20
> commit c4d0c3b097f7584772316ee4d64a09fe0e4ddfca upstream.
>=20
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.
[...]

This caused a serious regression and requires a second fix:

commit af24ee9ea8d532e16883251a6684dfa1be8eec29
Author: Alex Elder <aelder@sgi.com>
Date:   Tue Mar 1 17:50:00 2011 +0000

    xfs: zero proper structure size for geometry calls

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-nQoxiCZVjwEmDegYsNt3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaZh7ee/yOyVhhEJAQqZFA//RjHS5IC6W4StDXEvPrbkLqzq9lOFpc7d
KCGiZJfg3uLcLhaTMf5csX721+B8zYtaUSAdeTTau2aZQK201XUzla0JWE46gdyQ
moHYgJAao7d4wK5JbmRFpM1wY8e2jHNnWCKoGvTf53q57yYsliLR9fGqrAEELN4r
l3n0279bmy8p8/BcquTTpLnRYZoRUXL127ZqF3CbL82aWcm3FPr4tT8PMeOyeO8C
sBCCOTnF5bM6akS2raw279u5UHWcciMJfPyPJ2YHLGADb0cph7M8EBUsQKoQ3R+u
IDq7ufES7YvcKLecwPGUmYhIrw17ISVpXho/whWgGBsLF2ki4gn0r1jdwwg6Lfqd
bQ4Kfez5BcPJ3ndUXfJ4/jDnKuKLtPv5H04z+dZS9fT7QA1PsmPE0iwav7Z+s6Tr
rs6RXd6KxG81TClVpLEvafaUDcun2AgFK9GD25q8zUTQDmAbfVXUQ9+37DLbT2Kw
Co4RoQlYcP/je/hETcGVBXQVEQMcmwpd7tmkoaAW1Jqgvv0ygTy5G4b5z2wcZtYe
C2gMq76iIMqZPw+sF5eUwoSxJ4LkoMaW87ppb6PlzKwIg7l64veI9t5dRMyRKyjP
DlsuxtRHws/ekmqB7NIzewX1L1Azvp22h4j3inXC2B5obNoeSAcUVAENKdqvN1uH
+baHFsu5GPQ=
=FBiY
-----END PGP SIGNATURE-----

--=-nQoxiCZVjwEmDegYsNt3--
