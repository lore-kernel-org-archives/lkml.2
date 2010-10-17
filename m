Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0JQJN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:13:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58152 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0JQJN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:13:26 -0400
Date: Sun, 17 Oct 2010 20:13:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
Message-Id: <20101017201318.4e1ac3b0.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTi=ZFUkXebqw9-NUzT48KK58PyaJF7DSpxKJeGm8@mail.gmail.com>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101017092621.67ac74e0.sfr@canb.auug.org.au>
	<AANLkTi=ZFUkXebqw9-NUzT48KK58PyaJF7DSpxKJeGm8@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Oct_2010_20_13_18_+1100_BI9ZTOIzZBeA5/Sn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Oct_2010_20_13_18_+1100_BI9ZTOIzZBeA5/Sn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Sun, 17 Oct 2010 10:01:03 +0200 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> Strange...
>=20
> $ wget http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/; grep
> inode_set index.html
> --2010-10-17 09:59:35--
> http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/
> Resolving kisskb.ellerman.id.au... 203.10.76.25
> Connecting to kisskb.ellerman.id.au|203.10.76.25|:80... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 272362 (266K) [text/html]
> Saving to: `index.html'
>=20
> 100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>]
> 272,362     67.8K/s   in 3.9s
>=20
> 2010-10-17 09:59:39 (67.8 KB/s) - `index.html' saved [272362/272362]
>=20
> /scratch/kisskb/src/fs/9p/vfs_inode.c:1267: error: implicit
> declaration of function &#39;inode_setattr&#39;
> $
>=20
> Yep, it's there.

Ah, light dawns ... kisskb, when it gets a failure, attempts to do a
bisect between the failing kernel and the last kernel that built.
Consequently, the log of the bisect attempts will contain some of the
other errors that occurred since the kernel built correctly.  (As an
aside, the bisect script appears not to work very well ... :-( )

You were unlucky here that the m68k build went through a series of
different build problems without getting a good build.

You could try cutting the log off after seeing "make failed, trying to
bisect".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__17_Oct_2010_20_13_18_+1100_BI9ZTOIzZBeA5/Sn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMur4uAAoJEDMEi1NhKgbsXuAH/3RIg/QLQEns1TqHSBbw77Mg
jghqLwfZqH9njkeS1SHqHf9RwLKMgSyAHPMXwP9yrCUHs2kmk9cWg/HB/FqHVX3S
iXYXXq+qRlCxD2RqkdGWnWK4gJig2yH7/74q0Y37kmwhXMmzk13gPh95DRKNkBR2
wmI+Zk77MokRXCLdZp46YLqZpgkw2Oqu4Xd0ftOArlPsi+1xPK8kpjOuJQRJF950
ejgXRrn1oxODWwuibphaJMfzIxqq1NVVtm+rW6KKzo3Mp72XYGHuf1+FAey7/Z0x
WycuwxS+PU0+TTSP2hEn7kqX9l/d+0rq03brIhzVsBB/zdVVj5dydb2VZqdNURc=
=hjlu
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Oct_2010_20_13_18_+1100_BI9ZTOIzZBeA5/Sn--
