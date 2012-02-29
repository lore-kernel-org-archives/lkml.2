Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2B2RWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:22:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab2B2RWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:22:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.43.49.201 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330536308.3545.158.camel@sauron.fi.intel.com>
Subject: Re: [patch] Adding Secure Deletion to UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 19:25:08 +0200
In-Reply-To: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3bY69MkNSulJmrlkXsOv"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3bY69MkNSulJmrlkXsOv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-09 at 16:24 +0100, Joel Reardon wrote:
>=20
> Each data nodes includes a reference to a key in the KSA. This key is rea=
d and=20
> used to decrypt the data. When a new data node is written, an unused key =
is=20
> selected from the KSA and used to encrypt the data node. The reference to=
 the=20
> key is then included with the node. The keys in the KSA are written befor=
e=20
> actually being used to encrypt data. To securely delete a data node, we s=
imply=20
> mark the corresponding key position as deleted, and during the next purgi=
ng=20
> operation the KSA erase block that contains the key is then updated to a=
=20
> version that does not contain the key.

Why do you need to have your '__u64 crypto_lookup' both in the data node
and the index? Isn't it enough to have them only inside the data nodes?
ubifs_branch anyway points to the data node and you can read your
'crypto_lookup' from there.

--=20
Best Regards,
Artem Bityutskiy

--=-3bY69MkNSulJmrlkXsOv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTl91AAoJECmIfjd9wqK0JJcP/AqCnbP9BH9mBFltA8ygnwvt
BwPhEl/2lcr6ajmFsDgn2B5Z9juo+2Ba6UcYs4eARob87rtnwEzMQDakp+sg7uPd
SPVXOCdHC5L2+2axFZOUDTCGbGMLm8fO1gxPFJnH9NmwpnP5lJH33kaf/jcxPQvY
l6wrutaFdN9cIo2UkRVQtOKV++JqV06H7U+4ABhImRB0eu9cUMFA12hOA46+mIw6
WAysYzd66pfrNUCedxBUycwIg2ckPfOgeESsoCMQB8HIRpmrrrboLRI/aekmbBa5
tN0RUvuXeiJAjJ//3+g1oaVykPVr8JGjvNi2dHmP5Oiu/izHx5d4v7F6xc0mdvcC
VpJ7FqssiPTKCkzAv2dI1tItfHoinjNtkwfKMDmIBSEZJSbsLo/WNdosyv+uhvnw
5kmMbh8j/CtYq6a9OFq3XPcwZCCSbw6FfzCwtogHMd29p2CKpl4OT7NeOlfEDM+G
HG3JTMF9IJUXwvDnInY86lDGLHk2wOvqHVjC2uCaNHpPG1xc0YVIudaJYxH9MAgv
4rvQdbEsjlfJ10gzPzJ3pp2pmib3fe6SdeHXMh36IZoptsv7y0M1DSL+8VRMk683
m0rf7xBxTFc/6nLupPxmbZP50VaUKGCeydian9fhfxv+sOrN3U21wtju4YBXf61J
NZdafpvQGyjR7THchgZ7
=/RSv
-----END PGP SIGNATURE-----

--=-3bY69MkNSulJmrlkXsOv--

