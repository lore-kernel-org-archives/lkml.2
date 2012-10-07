Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab2JGS1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:27:18 -0400
Received: from bues.ch ([80.190.117.144]:41164 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab2JGS1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:27:11 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2012 14:27:10 EDT
Date: Sun, 7 Oct 2012 20:05:01 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: walter harms <wharms@bfs.de>, kernel-janitors@vger.kernel.org,
        rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/13] drivers/media/tuners/fc0011.c: use macros for
 i2c_msg initialization
Message-ID: <20121007200501.757a1ce6@milhouse>
In-Reply-To: <alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	<1349624323-15584-11-git-send-email-Julia.Lawall@lip6.fr>
	<5071B147.3010708@bfs.de>
	<alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.xXbt9B3o._hAnK.C27euRq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.xXbt9B3o._hAnK.C27euRq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 7 Oct 2012 18:50:31 +0200 (CEST)
Julia Lawall <julia.lawall@lip6.fr> wrote:

> >> @@ -97,10 +96,8 @@ static int fc0011_readreg(struct fc0011_priv *priv,=
 u8 reg, u8 *val)
> >>  {
> >>  	u8 dummy;
> >>  	struct i2c_msg msg[2] =3D {
> >> -		{ .addr =3D priv->addr,
> >> -		  .flags =3D 0, .buf =3D &reg, .len =3D 1 },
> >> -		{ .addr =3D priv->addr,
> >> -		  .flags =3D I2C_M_RD, .buf =3D val ? : &dummy, .len =3D 1 },
> >> +		I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
> >> +		I2C_MSG_READ(priv->addr, val ? : &dummy, sizeof(dummy)),
> >>  	};
> >>
> >
> > This dummy looks strange, can it be that this is used uninitialised ?
>=20
> I'm not sure to understand the question.  The read, when it happens in=20
> i2c_transfer will initialize dummy.  On the other hand, I don't know what=
=20
> i2c_transfer does when the buffer is NULL and the size is 1.  It does not=
=20
> look very elegant at least.

Well its use case is if you only care about the side effects and not the ac=
tual data
returned by the read operation.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/.xXbt9B3o._hAnK.C27euRq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQccRNAAoJEPUyvh2QjYsOe2IQAK6EJr6davwpTYnkRZxsZqDz
Wx2YUMI3aCWcrq0AL1bOD22gdM3+lrTXJ/q+XxaxqGaqES9OV8iZpmiWBGRWlQgi
mARnJ8KwG19yHFHKyw4cz64tP0PF4PhfdpdC8SL+fWwrFqlaI23XirLKg/gML3Iw
ptdsTobacaNsaHm8GM4yq6EZRQIOhiHgalhIx7okhkcauvSNKKRBSVDBkU7/99u3
ykEZb6GbHW0T7gkXd9cU969D/O5zeLMDu/G33TmXP7PASnwlfbQcSWa6vdSvMfsi
YrCUuxBlH3XrqdzrECOQX25zGCDYRkTtyBylcwGR+QHkLXX+iD31Q6XmwnzgWwI5
ONosmnpVA/qCGOuUhEej/dIyZXVvLpMhaj4KaZ0OGAR3dQWuoVfD4CzDZkHlFFHj
DgNTroLOSwTGIg/XJkMSgwL/ZxRX7+2WFugrpKPC+DjZGD0a+xS0ShIUYZlsw/fN
rLMy84cSEdrurcCELVp7oR5F2sCWqo5nTyPkwjA6ENLCwtT9xB7LMPrHJgQHqrpp
Hz97qiz5Vw3P7Xta6u/OZtjS3dCSbWjeAvm/3GE/Vt+tL0nH8wJpk/nksi2cgkJX
EI+cOkMvU4P+pIalk6kixI1wsj1zKcLniBY/w1x57B4E9eXAAgFykLgNwaoAyNAE
rDywYLI/SJ2ejPJnSZmk
=j5OD
-----END PGP SIGNATURE-----

--Sig_/.xXbt9B3o._hAnK.C27euRq--
