Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2JQAw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:52:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39025 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2JQAwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:52:25 -0400
Date: Wed, 17 Oct 2012 11:52:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20121017115217.0ffa47d478ea758aaaccab76@canb.auug.org.au>
In-Reply-To: <20121017114157.6abc8a3e1e6a62048addd52d@canb.auug.org.au>
References: <20121017114157.6abc8a3e1e6a62048addd52d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Oct_2012_11_52_17_+1100_X=Ls+2B7teE_/TJd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Oct_2012_11_52_17_+1100_X=Ls+2B7teE_/TJd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, 17 Oct 2012 11:41:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the security tree got a conflict in
> net/dns_resolver/dns_key.c between commit c6089735e724 ("userns: net:
> Call key_alloc with GLOBAL_ROOT_UID, GLOBAL_ROOT_GID instead of 0, 0")
> from Linus' tree and commit f8aa23a55f81 ("KEYS: Use keyring_alloc() to
> create special keyrings") from the security tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc net/dns_resolver/dns_key.c
> index 8aa4b11,b53bb4a..0000000
> --- a/net/dns_resolver/dns_key.c
> +++ b/net/dns_resolver/dns_key.c
> @@@ -259,11 -259,10 +259,11 @@@ static int __init init_dns_resolver(voi
>   	if (!cred)
>   		return -ENOMEM;
>  =20
> - 	keyring =3D key_alloc(&key_type_keyring, ".dns_resolver",
>  -	keyring =3D keyring_alloc(".dns_resolver", 0, 0, cred,
>  -				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
>  -				KEY_USR_VIEW | KEY_USR_READ,
>  -				KEY_ALLOC_NOT_IN_QUOTA, NULL);
> ++	keyring =3D keyring_alloc(".dns_resolver",
>  +			    GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
>  +			    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
>  +			    KEY_USR_VIEW | KEY_USR_READ,
>  +			    KEY_ALLOC_NOT_IN_QUOTA);

Oops, there should be a ", NULL" before the closing parenthesis above.  I
fixed that in my tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__17_Oct_2012_11_52_17_+1100_X=Ls+2B7teE_/TJd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfgFBAAoJEECxmPOUX5FEFU4QAKS9KnYCH6E85OHeL+qciJXu
5W8OAIQ61o45nNYkIQnK6578mjRtcXkkBo6zs1tT/121c0LJlH7Bx2xHKu3smO42
948rByqRyI+h23xq4yd7urYXTZZWe2ZM0TU2T/B7dXNKPWLqERoTGaTfP2P7W61+
N2ts/LH1zu//yQnPzMP6MGutWGDqm8d6eyEq0V/rHUG+NH6mcR3fuJQdTkzD94IY
zqLq83jckgLiIQiIEQ8u0pd8llkL0s2CZuacmOgWSpkwKnqY5WXo8z6f/34qMT3l
lLps5NjyN590sRQbNiMy9z1AtSXqts2FtJ0I+xMZqN/LDZkB0/wdBKt3xnPxZiqX
Nl3z2mmlOLkZWBTR6+LKjra1FnuZeFiBFl2xVBG0v7PjYJJtYWBAWkYeGOASb9A9
9cPp+mpjd57Uea1Yha4kypSMLek/EmTcjHe2i4Ilv/ZOcuNBKX68HtDUs8lGGUjU
P5My5rAXBadn7U9sIBxfXou26i43dvHJtjKotsSniPkcw9qkb4TIW4wHS3gOGhnK
f5au6uz2rJ1bKBsWMdTmrSyuNWeThmF1j5ew8J65nrigzDhdrdwOcACW98K8dtkZ
T7fBsPwRI3de53+UQ9M3LeaMQcj4VG93du8R0BG8kGXljTvh9GAqqG9sPFefXAjl
qo0jqAkP6aAm2Tt4kYB0
=6cTV
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Oct_2012_11_52_17_+1100_X=Ls+2B7teE_/TJd--
