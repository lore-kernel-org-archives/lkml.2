Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2ARVEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:04:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2ARVEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:04:10 -0500
Date: Wed, 18 Jan 2012 15:04:01 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dragonylffly <dragonylffly@163.com>, john.johansen@canonical.com,
        dustin.kirkland@gazzang.com, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: infinite loop bug
Message-ID: <20120118210400.GB20576@boyd>
References: <7f1e961d.f528.134efaf8348.Coremail.dragonylffly@163.com>
 <CA+55aFx7CV8wpDLfCr-pVVRxRyYgd2QdRXJSmp+UgrjSHyB1eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <CA+55aFx7CV8wpDLfCr-pVVRxRyYgd2QdRXJSmp+UgrjSHyB1eA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-18 12:49:17, Linus Torvalds wrote:
> Hmm.
>=20
> There are *two* cases where we do that "total_remaining_bytes"
> calculation. The same bug seems to exist both in ecryptfs_read() and
> ecryptfs_write().

ecryptfs_read() is ifdef'ed out, and has been for years, so I'll just go
ahead and kill that function for good.

>=20
> Possibly only the ecryptfs_write() one leads to an endless loop, but
> the read one looks suspicious too.
>=20
> Also, what protects things against this just being one nasty DoS
> attack - even if the code is fixed to not be an endless loop, it looks
> like a trivial "truncate()" can be used to generate a *practically*
> infinite write stream. At the very least, this should be KILLABLE. Or
> did I mis-read the code?

I think you're right. I'll start off with making it killable and then
see if there is anything else we can do.

Tyler

>=20
> Tyler, Dustin, others - comments? This looks nasty.
>=20
>                      Linus.
>=20
> 2012/1/17 dragonylffly <dragonylffly@163.com>:
> > Hi,
> > =A0 There is an infinite loop bug in eCryptfs, to make it present,
> > just truncate to generate a huge file (>=3D 4G) on a 32-bit machine und=
er
> > the plain text foleder mounted with eCryptfs, a simple command
> > 'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
> > therefore the following command 'truncate -s 4GB dummy' will not
> > trigger=A0this bug. The bug comes from a data overflow, the patch below=
 fixes
> > it.
> >
> > Cheers,
> > Li Wang
> >
> > ---
> >
> > signed-off-by: Li Wang <liwang@nudt.edu.cn>
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Yunchuan Wen (wenyunchuan@ky=
linos.com.cn)
> >
> > --- read_write.c.orig=A02012-01-18 10:39:26.000000000 +0800
> > +++ read_write.c=A02012-01-18 19:48:41.484196221 +0800
> > @@ -130,7 +130,7 @@
> > =A0=A0=A0pgoff_t ecryptfs_page_idx =3D (pos >> PAGE_CACHE_SHIFT);
> > =A0=A0=A0size_t start_offset_in_page =3D (pos & ~PAGE_CACHE_MASK);
> > =A0=A0=A0size_t num_bytes =3D (PAGE_CACHE_SIZE - start_offset_in_page);
> > -=A0=A0size_t total_remaining_bytes =3D ((offset + size) - pos);
> > +=A0=A0loff_t total_remaining_bytes =3D ((offset + size) - pos);
> >
> > =A0=A0=A0if (num_bytes > total_remaining_bytes)
> > =A0=A0=A0=A0num_bytes =3D total_remaining_bytes;
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPFzPAAAoJENaSAD2qAscKycgP/2hXWBSqY82PjqIvTOGQ6L7r
u1oJ+Q7pbiQz+jCXqCtDBPmLXuUwfOZzxRRUeYZrEiXo7nfF6e3BjvnoMynnv4ZO
i6sYOCZ4uLUxqBK2DTszacOwKBYI8BzqpT2OvWJGeBRtlmPlUGdvraQr8HuHPLWU
cGncwP1q+72rz7nYKHTQmwe9lRa4uS2aepceRrBdhyWQZLOSiR5/Jo00m7uYf08B
mpkWMfiA7XaMrzb2rBo1gEe0ZI6JZFnIBfHu5gnDHIhCdDm7jmCfjsChYJ8UDWCQ
QnJriGcDf1tmX9HFAtt7MxyBPdWXtZjrpDyV44Q436ZiPm0rsShMD2EC1V1HszSY
ziYYPL4thzoMrC9ewem/FXWEI+FUxVG6mWKxb0Iiuu2rTtk/7+VFhrlMuIFvoybs
XdoiW3Y1ZT7F6iM9VJJlEiebUQPbVORQxbZizAcw46gYH8326nQx5RHbrZ4irMxY
Hkv10ZlhrOr6pHWNl1i586zVlGk9hmdswlh09kUFD0/7vEl0rNFQ5vH/HtCleFOS
MdPje03qrvMrUKsSgARt3pBiw6TGvr3m51Ej4azyzLn6DknwbYK5m5y9GUqwr+QD
Gsnx0rYso1bJxZXqql4LhvntGwm4K7Cref80f8ddXXa2zecmVy4H/6bgRGbR33+J
e/00j+tlJPEXux0nftvV
=5yiE
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
