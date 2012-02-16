Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2BPEtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:49:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab2BPEtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:49:47 -0500
Message-ID: <1329367790.3048.168.camel@deadeye>
Subject: Re: [PATCH 2/2] kbuild: Only build linux-image package for UML
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Thu, 16 Feb 2012 04:49:50 +0000
In-Reply-To: <1329323907-7696-2-git-send-email-joerg.roedel@amd.com>
References: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
	 <1329323907-7696-2-git-send-email-joerg.roedel@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9l2lFovANsYBLa94WiBz"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9l2lFovANsYBLa94WiBz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-15 at 17:38 +0100, Joerg Roedel wrote:
> For user-mode Linux the other packages are not required. So
> only build the package with the linux-image in it.
>=20
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: maximilian attems <max@stro.at>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: debian-kernel@lists.debian.org
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Tested-by: Ben Hutchings <ben@decadent.org.uk>

But I've never touched UML either so we should get confirmation that
this really is the right thing to do.

Ben.

> ---
>  scripts/package/builddeb |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 39e3f30..0db889f 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -130,8 +130,10 @@ if grep -q '^CONFIG_MODULES=3Dy' .config ; then
>  	fi
>  fi
> =20
> -make headers_check
> -make headers_install INSTALL_HDR_PATH=3D"$libc_headers_dir/usr"
> +if [ "$ARCH" !=3D "um" ]; then
> +	make headers_check
> +	make headers_install INSTALL_HDR_PATH=3D"$libc_headers_dir/usr"
> +fi
> =20
>  # Install the maintainer scripts
>  # Note: hook scripts under /etc/kernel are also executed by official Deb=
ian
> @@ -263,8 +265,6 @@ Description: Linux kernel headers for $KERNELRELEASE =
on $arch
>   This is useful for people who need to build external modules
>  EOF
> =20
> -create_package "$kernel_headers_packagename" "$kernel_headers_dir"
> -
>  # Do we have firmware? Move it out of the way and build it into a packag=
e.
>  if [ -e "$tmpdir/lib/firmware" ]; then
>  	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
> @@ -291,7 +291,11 @@ Description: Linux support headers for userspace dev=
elopment
>   are used by the installed headers for GNU glibc and other system librar=
ies.
>  EOF
> =20
> -create_package "$libc_headers_packagename" "$libc_headers_dir"
> +if [ "$ARCH" !=3D "um" ]; then
> +	create_package "$kernel_headers_packagename" "$kernel_headers_dir"
> +	create_package "$libc_headers_packagename" "$libc_headers_dir"
> +fi
> +
>  create_package "$packagename" "$tmpdir"
> =20
>  exit 0
> --=20
> 1.7.5.4
>=20
>=20
>=20

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-9l2lFovANsYBLa94WiBz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATzyK7ue/yOyVhhEJAQq+OxAAhOkl672K7dU+vvH9mn/DdLXW0uYoiClg
NAX/rlJGzpRV+kxPy4OLXRWNMW2xNEEpj6r+n/8eMCNAikSDwC+6mRloLlT36Uku
oqSQYMPZXZkjBBSmTDbzLug/FfKJRos18D26rX4gI5MpVoTlued7IGc4D0xwRWHg
lERcEImz7tx6mTBYQKHN+ljF6YRsHD3/SK0Qk+UtEzRkwzKkG6VUqWgDPemDLBYY
H41MIHdAtD5VZbngeTz/PTizb9po0LYD4F8ei3fKTijKUgCpctN1SydyqsKspvRu
wNgmf+x3XW3zKcfohKrXxBj/Nyw9KvkTdi8fvtPZ3XzXfCe9vkkxP0Stet9kwNcM
We58kyHNe8uP9k1h1kSoFor+Wkazt0d77QB2z0KCURFBKoMmtKPgTRD7mSet/7mE
fGvDVh7PMeMhor+XwNavMPTgCFwZNwAn0Ilk7dthzDD+bWxCIKPv5mfjInDinU9x
Tfi4/zDIKoA74hKSnV2SZdVQu2/+9/KuS6SaL6TfMB9LVBeMi6FSe2Bdk3rM28dm
Xb972N+HEucPP6qRqIgYOXfy82z7Kv/VIjrWPzJbAnuQ6B5UBb0SvcedHkN+HabP
x1pRwUhFYr9noVUJlug1w7jfBQ2jt8zFKNXYqQqgVg4cqwSujgezmirQe/1o9I4Q
dYyrnyfQtV8=
=FLAF
-----END PGP SIGNATURE-----

--=-9l2lFovANsYBLa94WiBz--
