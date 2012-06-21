Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2FUBp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:45:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52032 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab2FUBpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:45:55 -0400
Date: Thu, 21 Jun 2012 11:45:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: linux-next: Tree for Jun 20 (hweight return type)
Message-Id: <20120621114546.1e5df51bd231ee481d63705c@canb.auug.org.au>
In-Reply-To: <4FE27471.8050505@xenotime.net>
References: <20120620173536.b856bbd97497cf02ddf8d6d2@canb.auug.org.au>
	<4FE27471.8050505@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Jun_2012_11_45_46_+1000_3CaoF_LSqfkKBwPq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jun_2012_11_45_46_+1000_3CaoF_LSqfkKBwPq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jun 2012 18:10:09 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> Someone changes the return type of __const_hweight8() to
> (unsigned long).  That causes printk format warnings when
> hweight8/16() etc. is passed a constant:

That would be "include/linux/bitops.h: fix warning" from the akpm tree
(adding cc's).

>=20
> drivers/input/joystick/analog.c:412:4: warning: format '%d' expects type =
'int', but argument 4 has type 'long unsigned int'
> drivers/input/joystick/analog.c:412:4: warning: format '%d' expects type =
'int', but argument 5 has type 'long unsigned int'
> drivers/input/joystick/analog.c:416:5: warning: format '%d' expects type =
'int', but argument 5 has type 'long unsigned int'
>=20
>=20
> Note that in
>=20
> #define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __=
arch_hweight8(w))
>=20
> __arch_hweight*() still returns unsigned int while __const_hweight*()
> returns unsigned long.  This can't be good, can it?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Jun_2012_11_45_46_+1000_3CaoF_LSqfkKBwPq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4nzKAAoJEECxmPOUX5FE9joP/0Rrm1hA6MFNtbA7PK9Pw09E
RoZsBpoQuzgJltDa+tzYIy3JoId6VykPhyQXysBCJ0hH/BYtSkQ0Z/N7gSa/AT3J
i0N359FcTpluLCOjbrxE3E56Cka5sn7B55EmYIrtBxBtzsK9dNYJapvFCVAbOiJC
z7JrJh5FF4cKpKOiqHZaPRB+ZzR1LwhWyMyBjjyfM6bVR+it2OBfb35grgD6Op/7
yUJhEOq/DqF4w54oQ/Flq+ChnzNpfvTivLVYvHFKC/qB7eJdNwiO7Wel8uclRb9m
zvWOJTXq/xpYVPHdAwjwER1cr+44LuQbVBM2gw2djZ4r7mpahOORcH3PdJyhojLU
gGzu+k25fqrqqnT9H8DjYXUShRmBVhMwp15dlfKndzGTfy3pPBdjtkIdwyf5Fxqj
eT7Xg64uYWUXWMoTQQfD0RWpoFmTVkZzSyRh/F+h2I0qeAErZlbfWAvwAm5l7puk
/hcTIAAfBk1KJpZLYjQy8KUNnekeZ1qd5Do1KlnddfU09DVEGGv+tMBgo5N7FaHb
e0fKU6we6nHJ4svs6b1oQYqKY8eeTIpI+ZeGPTN0kgcaXsUB1mGB3IlkRpNgdKW6
40J6indQwBKfSZPDWK/e1HhmTmtL+IeXTAXlLj99q1uIt22s2F/krYXA6BOTK/rj
X51sDSzjWCxR+Klgba5V
=/Kw7
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jun_2012_11_45_46_+1000_3CaoF_LSqfkKBwPq--
