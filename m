Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab0JGGym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 02:54:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41719 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0JGGyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 02:54:41 -0400
Date: Thu, 7 Oct 2010 08:54:38 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Warn on non-executable files
	created with non 100644 file permissions
Message-ID: <20101007065438.GB12741@pengutronix.de>
References: <1286407891.32241.21.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <1286407891.32241.21.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 06, 2010 at 04:31:31PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2039acd..6f8a1d4 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1346,6 +1346,14 @@ sub process {
>  			}
>  		}
> =20
> +		if ($rawline =3D~ /^ create mode (\d+) ([\w\.\/\-]+)$/) {

Do you really need to escape ./- in the character-class? ISTR this is not
needed.

> +			my $mode =3D $1;
> +			my $file =3D $2;
> +			if ($mode ne "100644" && !($file =3D~ /\.(sh|pl|py|awk)$/)) {
> +				WARN("FILE '$file' should probably use file permission 100644 not $m=
ode\n" . $herecurr);
> +			}

What about checking for no filename extension, too, and changing the messag=
e to
something like "use proper file permission or proper extension"?

> +		}
> +
>  # Check for wrappage within a valid hunk of the file
>  		if ($realcnt !=3D 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
>  			ERROR("patch seems to be corrupt (line wrapped?)\n" .
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkytbq4ACgkQD27XaX1/VRvgjACgkMVhWxA7xNS2QkNyi2kUxact
5qYAn0XD43h1A/6cVvIeJU2hIjwMI3Zi
=Hat0
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
