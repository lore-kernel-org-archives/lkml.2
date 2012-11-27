Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab2K0CW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:22:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38430 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878Ab2K0CWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:22:25 -0500
Message-ID: <1353982939.4266.38.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 028/270] ext4: remove erroneous
 ext4_superblock_csum_set() in update_backups()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Tao Ma <boyu.mt@taobao.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 02:22:19 +0000
In-Reply-To: <1353949160-26803-29-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-29-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IQTzQqcRcUiHytPRPJ+M"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IQTzQqcRcUiHytPRPJ+M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Tao Ma <boyu.mt@taobao.com>
>=20
> commit bef53b01faeb791e27605cba1a71ba21364cb23e upstream.
>=20
> The update_backups() function is used to backup all the metadata
> blocks, so we should not take it for granted that 'data' is pointed to
> a super block and use ext4_superblock_csum_set to calculate the
> checksum there.  In case where the data is a group descriptor block,
> it will corrupt the last group descriptor, and then e2fsck will
> complain about it it.
>=20
> As all the metadata checksums should already be OK when we do the
> backup, remove the wrong ext4_superblock_csum_set and it should be
> just fine.
>=20
> Reported-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> [ herton: adjust context ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This should also be applicable to 3.6.

Ben.

> ---
>  fs/ext4/resize.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index b0bdd10..dc1affc 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -979,8 +979,6 @@ static void update_backups(struct super_block *sb,
>  		goto exit_err;
>  	}
> =20
> -	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
> -
>  	while ((group =3D ext4_list_backups(sb, &three, &five, &seven)) < last)=
 {
>  		struct buffer_head *bh;
> =20

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-IQTzQqcRcUiHytPRPJ+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULQj2+e/yOyVhhEJAQqv/RAAxSEoUf07KEbtGURtJjPXd+TZgvwwLPbz
OxZR/eS5RfHWtI7prJS/y40kuwlaNp0Iqaev26z73DmMEhv6Zhd8xLNCWgx4YEsY
2A1pX281cUvOIIFUORHf3OAAPOZ6aRabSYqCdn2yH7n+LeQGgEuqaE/US5LmMq7a
EryfXoU9MMGvs7CEfbF2OKMooTc14npS+pKkO3Q1XQYu02qAo5Z/na6kRO7bc/ji
rjII+Xc+AxvRJ0PYwc/lIaD61ZbK0BKhPk63bh4pGtoUDThkMq9qPn1g9qPmELz9
pE8t8BmlSdj8yd0gTzKaPOX02n3C4DAVZcsqtwSAMfN+RuXamcA6/tjxprSok6eJ
PjImAKfr+cCvAMXAhmFoGu2HDjp3dlVqxRYWOz2tVfoG9pv2KetxvoHJGGNgSpQe
KL1qn+TesRh1JRks8thhkkKyOXHW0oAJ698Lf9YqDbfHdf4OmxsD9rYUi0kyy/XD
IMk4oyAE/K4VPWwE7OSsxXOBCdR5K478wnJMHK6Y4NHgEelbAgOuCpwwau/ieHiu
ywOHYlNzSd+XEbqkgMo4lRawRO+dQ/nyFrl2+x8Uwq4fkhtBQ4ex6wI1G6yCIeDj
GWa984NWE0vtE3qi+s0cICtB5YgF6YH6uU5b0hdYyqoN92C9o85JkIU41likwEqB
NJLFVKbNp/8=
=C9Vj
-----END PGP SIGNATURE-----

--=-IQTzQqcRcUiHytPRPJ+M--
